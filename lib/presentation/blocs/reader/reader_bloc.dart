import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/book.dart';
import '../../../domain/entities/highlight.dart';
import '../../../domain/entities/reading_progress.dart';
import '../../../domain/usecases/load_reader_data.dart';
import '../../../domain/usecases/save_reading_progress.dart';
import '../../../domain/usecases/update_highlight.dart';
import '../../../domain/usecases/update_reader_settings.dart';

part 'reader_event.dart';
part 'reader_state.dart';

class ReaderBloc extends Bloc<ReaderEvent, ReaderState> {
  ReaderBloc({
    required this.loadReaderData,
    required this.saveReadingProgress,
    required this.updateReaderSettings,
    required this.updateHighlight,
  }) : super(ReaderInitial()) {
    on<ReaderOpened>(_onReaderOpened);
    on<ReaderScrollPositionChanged>(_onReaderScrollPositionChanged);
    on<ReaderSettingsChanged>(_onReaderSettingsChanged);
    on<ReaderThemeChanged>(_onReaderThemeChanged);
    on<ReaderHighlightAdded>(_onReaderHighlightAdded);
    on<ReaderHighlightColorChanged>(_onReaderHighlightColorChanged);
    on<ReaderHighlightDeleted>(_onReaderHighlightDeleted);
    on<ReaderJumpToSavedPositionRequested>(_onReaderJumpToSavedPositionRequested);
    on<ReaderJumpToHighlightRequested>(_onReaderJumpToHighlightRequested);
  }

  final LoadReaderData loadReaderData;
  final SaveReadingProgress saveReadingProgress;
  final UpdateReaderSettings updateReaderSettings;
  final UpdateHighlight updateHighlight;

  Timer? _debounceTimer;

  Future<void> _onReaderOpened(
    ReaderOpened event,
    Emitter<ReaderState> emit,
  ) async {
    emit(ReaderLoading());
    try {
      final data = await loadReaderData(event.bookId);
      final progress = data.progress ?? _defaultProgress(event.bookId);
      emit(ReaderReady(
        book: data.book,
        themeMode: progress.themeMode,
        typographySettings: TypographySettings.fromProgress(progress),
        scrollOffset: progress.scrollOffset,
        progressPercent: progress.progressPercent,
        highlights: data.highlights,
        pendingJumpHighlightId: null,
      ));
    } catch (error) {
      emit(ReaderError(message: error.toString()));
    }
  }

  Future<void> _onReaderScrollPositionChanged(
    ReaderScrollPositionChanged event,
    Emitter<ReaderState> emit,
  ) async {
    if (state is! ReaderReady) return;
    final current = state as ReaderReady;
    emit(current.copyWith(
      scrollOffset: event.offset,
      progressPercent: event.progressPercent,
    ));
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 800), () async {
      final updated = _progressFromState(current, event.offset, event.progressPercent);
      await saveReadingProgress(updated);
    });
  }

  Future<void> _onReaderSettingsChanged(
    ReaderSettingsChanged event,
    Emitter<ReaderState> emit,
  ) async {
    if (state is! ReaderReady) return;
    final current = state as ReaderReady;
    final settings = current.typographySettings.copyWith(
      fontSize: event.fontSize,
      lineHeight: event.lineHeight,
      fontFamily: event.fontFamily,
      paragraphSpacing: event.paragraphSpacing,
    );
    emit(current.copyWith(typographySettings: settings));
    final progress = _progressFromState(current, current.scrollOffset, current.progressPercent)
        .copyWith(
          fontSize: settings.fontSize,
          lineHeight: settings.lineHeight,
          fontFamily: settings.fontFamily,
          paragraphSpacing: settings.paragraphSpacing,
          lastUpdated: DateTime.now().millisecondsSinceEpoch,
        );
    await updateReaderSettings(progress);
  }

  Future<void> _onReaderThemeChanged(
    ReaderThemeChanged event,
    Emitter<ReaderState> emit,
  ) async {
    if (state is! ReaderReady) return;
    final current = state as ReaderReady;
    emit(current.copyWith(themeMode: event.themeMode));
    final progress = _progressFromState(current, current.scrollOffset, current.progressPercent)
        .copyWith(
          themeMode: event.themeMode,
          lastUpdated: DateTime.now().millisecondsSinceEpoch,
        );
    await updateReaderSettings(progress);
  }

  Future<void> _onReaderHighlightAdded(
    ReaderHighlightAdded event,
    Emitter<ReaderState> emit,
  ) async {
    if (state is! ReaderReady) return;
    final current = state as ReaderReady;
    final highlight = Highlight(
      id: 0,
      bookId: current.book.id,
      startIndex: event.startIndex,
      endIndex: event.endIndex,
      selectedText: event.text,
      colorHex: event.colorHex,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    final id = await updateHighlight.add(highlight);
    final newHighlight = Highlight(
      id: id,
      bookId: highlight.bookId,
      startIndex: highlight.startIndex,
      endIndex: highlight.endIndex,
      selectedText: highlight.selectedText,
      colorHex: highlight.colorHex,
      createdAt: highlight.createdAt,
      note: highlight.note,
    );
    emit(current.copyWith(highlights: [newHighlight, ...current.highlights]));
  }

  Future<void> _onReaderHighlightColorChanged(
    ReaderHighlightColorChanged event,
    Emitter<ReaderState> emit,
  ) async {
    if (state is! ReaderReady) return;
    final current = state as ReaderReady;
    final highlight = current.highlights.firstWhere((h) => h.id == event.highlightId);
    final updated = highlight.copyWith(colorHex: event.colorHex);
    await updateHighlight.update(updated);
    final highlights = current.highlights
        .map((h) => h.id == event.highlightId ? updated : h)
        .toList();
    emit(current.copyWith(highlights: highlights));
  }

  Future<void> _onReaderHighlightDeleted(
    ReaderHighlightDeleted event,
    Emitter<ReaderState> emit,
  ) async {
    if (state is! ReaderReady) return;
    final current = state as ReaderReady;
    await updateHighlight.delete(event.highlightId);
    final highlights = current.highlights.where((h) => h.id != event.highlightId).toList();
    emit(current.copyWith(highlights: highlights));
  }

  Future<void> _onReaderJumpToSavedPositionRequested(
    ReaderJumpToSavedPositionRequested event,
    Emitter<ReaderState> emit,
  ) async {
    if (state is! ReaderReady) return;
    final current = state as ReaderReady;
    emit(current.copyWith(pendingJumpHighlightId: null));
  }

  Future<void> _onReaderJumpToHighlightRequested(
    ReaderJumpToHighlightRequested event,
    Emitter<ReaderState> emit,
  ) async {
    if (state is! ReaderReady) return;
    final current = state as ReaderReady;
    emit(current.copyWith(pendingJumpHighlightId: event.highlightId));
  }

  ReadingProgress _defaultProgress(String bookId) {
    return ReadingProgress(
      bookId: bookId,
      scrollOffset: 0,
      progressPercent: 0,
      fontSize: 18,
      lineHeight: 1.6,
      fontFamily: 'Merriweather',
      paragraphSpacing: 12,
      themeMode: 'light',
      lastUpdated: DateTime.now().millisecondsSinceEpoch,
    );
  }

  ReadingProgress _progressFromState(
    ReaderReady state,
    double offset,
    double progress,
  ) {
    return ReadingProgress(
      bookId: state.book.id,
      scrollOffset: offset,
      progressPercent: progress,
      fontSize: state.typographySettings.fontSize,
      lineHeight: state.typographySettings.lineHeight,
      fontFamily: state.typographySettings.fontFamily,
      paragraphSpacing: state.typographySettings.paragraphSpacing,
      themeMode: state.themeMode,
      lastUpdated: DateTime.now().millisecondsSinceEpoch,
    );
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
