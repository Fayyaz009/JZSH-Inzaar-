part of 'reader_bloc.dart';

abstract class ReaderEvent extends Equatable {
  const ReaderEvent();

  @override
  List<Object?> get props => [];
}

class ReaderOpened extends ReaderEvent {
  final String bookId;

  const ReaderOpened(this.bookId);

  @override
  List<Object?> get props => [bookId];
}

class ReaderScrollPositionChanged extends ReaderEvent {
  final double offset;
  final double progressPercent;

  const ReaderScrollPositionChanged(this.offset, this.progressPercent);

  @override
  List<Object?> get props => [offset, progressPercent];
}

class ReaderSettingsChanged extends ReaderEvent {
  final double fontSize;
  final double lineHeight;
  final String fontFamily;
  final double paragraphSpacing;

  const ReaderSettingsChanged({
    required this.fontSize,
    required this.lineHeight,
    required this.fontFamily,
    required this.paragraphSpacing,
  });

  @override
  List<Object?> get props => [fontSize, lineHeight, fontFamily, paragraphSpacing];
}

class ReaderThemeChanged extends ReaderEvent {
  final String themeMode;

  const ReaderThemeChanged(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}

class ReaderHighlightAdded extends ReaderEvent {
  final int startIndex;
  final int endIndex;
  final String text;
  final String colorHex;

  const ReaderHighlightAdded({
    required this.startIndex,
    required this.endIndex,
    required this.text,
    required this.colorHex,
  });

  @override
  List<Object?> get props => [startIndex, endIndex, text, colorHex];
}

class ReaderHighlightColorChanged extends ReaderEvent {
  final int highlightId;
  final String colorHex;

  const ReaderHighlightColorChanged(this.highlightId, this.colorHex);

  @override
  List<Object?> get props => [highlightId, colorHex];
}

class ReaderHighlightDeleted extends ReaderEvent {
  final int highlightId;

  const ReaderHighlightDeleted(this.highlightId);

  @override
  List<Object?> get props => [highlightId];
}

class ReaderJumpToSavedPositionRequested extends ReaderEvent {}

class ReaderJumpToHighlightRequested extends ReaderEvent {
  final int highlightId;

  const ReaderJumpToHighlightRequested(this.highlightId);

  @override
  List<Object?> get props => [highlightId];
}
