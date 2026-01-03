part of 'highlights_bloc.dart';

abstract class HighlightsEvent extends Equatable {
  const HighlightsEvent();

  @override
  List<Object?> get props => [];
}

class HighlightsLoaded extends HighlightsEvent {
  final String? bookId;

  const HighlightsLoaded({this.bookId});

  @override
  List<Object?> get props => [bookId];
}

class HighlightsSearched extends HighlightsEvent {
  final String query;
  final String? bookId;

  const HighlightsSearched(this.query, {this.bookId});

  @override
  List<Object?> get props => [query, bookId];
}

class HighlightsFilteredByColor extends HighlightsEvent {
  final String? colorHex;
  final String? bookId;

  const HighlightsFilteredByColor(this.colorHex, {this.bookId});

  @override
  List<Object?> get props => [colorHex, bookId];
}

class HighlightTapped extends HighlightsEvent {
  final int highlightId;

  const HighlightTapped(this.highlightId);

  @override
  List<Object?> get props => [highlightId];
}
