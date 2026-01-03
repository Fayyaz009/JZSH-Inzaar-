import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/highlight.dart';
import '../../../domain/usecases/get_highlights.dart';

part 'highlights_event.dart';
part 'highlights_state.dart';

class HighlightsBloc extends Bloc<HighlightsEvent, HighlightsState> {
  HighlightsBloc({required this.getHighlights}) : super(HighlightsInitial()) {
    on<HighlightsLoaded>(_onHighlightsLoaded);
    on<HighlightsSearched>(_onHighlightsSearched);
    on<HighlightsFilteredByColor>(_onHighlightsFilteredByColor);
    on<HighlightTapped>(_onHighlightTapped);
  }

  final GetHighlights getHighlights;
  String? _activeFilter;
  String _query = '';

  Future<void> _onHighlightsLoaded(
    HighlightsLoaded event,
    Emitter<HighlightsState> emit,
  ) async {
    emit(HighlightsLoading());
    try {
      final groups = await getHighlights(bookId: event.bookId);
      emit(HighlightsLoadedState(
        items: _filterGroups(groups),
        activeFilter: _activeFilter,
        query: _query,
        selectedHighlightId: null,
      ));
    } catch (error) {
      emit(HighlightsError(message: error.toString()));
    }
  }

  Future<void> _onHighlightsSearched(
    HighlightsSearched event,
    Emitter<HighlightsState> emit,
  ) async {
    _query = event.query;
    add(HighlightsLoaded(bookId: event.bookId));
  }

  Future<void> _onHighlightsFilteredByColor(
    HighlightsFilteredByColor event,
    Emitter<HighlightsState> emit,
  ) async {
    _activeFilter = event.colorHex;
    add(HighlightsLoaded(bookId: event.bookId));
  }

  void _onHighlightTapped(
    HighlightTapped event,
    Emitter<HighlightsState> emit,
  ) {
    if (state is! HighlightsLoadedState) return;
    final current = state as HighlightsLoadedState;
    emit(current.copyWith(selectedHighlightId: event.highlightId));
  }

  List<BookHighlightsGroup> _filterGroups(List<BookHighlightsGroup> groups) {
    final filteredGroups = <BookHighlightsGroup>[];
    for (final group in groups) {
      final filtered = group.highlights.where((highlight) {
        final matchesQuery = _query.isEmpty ||
            highlight.selectedText.toLowerCase().contains(_query.toLowerCase());
        final matchesColor = _activeFilter == null || highlight.colorHex == _activeFilter;
        return matchesQuery && matchesColor;
      }).toList();
      if (filtered.isEmpty) continue;
      filteredGroups.add(BookHighlightsGroup(book: group.book, highlights: filtered));
    }
    return filteredGroups;
  }
}
