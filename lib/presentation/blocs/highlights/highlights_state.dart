part of 'highlights_bloc.dart';

abstract class HighlightsState extends Equatable {
  const HighlightsState();

  @override
  List<Object?> get props => [];
}

class HighlightsInitial extends HighlightsState {}

class HighlightsLoading extends HighlightsState {}

class HighlightsLoadedState extends HighlightsState {
  final List<BookHighlightsGroup> items;
  final String? activeFilter;
  final String query;
  final int? selectedHighlightId;

  const HighlightsLoadedState({
    required this.items,
    required this.activeFilter,
    required this.query,
    required this.selectedHighlightId,
  });

  HighlightsLoadedState copyWith({
    List<BookHighlightsGroup>? items,
    String? activeFilter,
    String? query,
    int? selectedHighlightId,
  }) {
    return HighlightsLoadedState(
      items: items ?? this.items,
      activeFilter: activeFilter ?? this.activeFilter,
      query: query ?? this.query,
      selectedHighlightId: selectedHighlightId,
    );
  }

  @override
  List<Object?> get props => [items, activeFilter, query, selectedHighlightId];
}

class HighlightsError extends HighlightsState {
  final String message;

  const HighlightsError({required this.message});

  @override
  List<Object?> get props => [message];
}
