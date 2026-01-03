part of 'library_bloc.dart';

abstract class LibraryState extends Equatable {
  const LibraryState();

  @override
  List<Object?> get props => [];
}

class LibraryInitial extends LibraryState {}

class LibraryLoading extends LibraryState {}

class LibraryLoaded extends LibraryState {
  final List<Book> books;
  final ContinueReadingItem? continueItem;
  final String? selectedBookId;

  const LibraryLoaded({
    required this.books,
    required this.continueItem,
    this.selectedBookId,
  });

  LibraryLoaded copyWith({
    List<Book>? books,
    ContinueReadingItem? continueItem,
    String? selectedBookId,
  }) {
    return LibraryLoaded(
      books: books ?? this.books,
      continueItem: continueItem ?? this.continueItem,
      selectedBookId: selectedBookId,
    );
  }

  @override
  List<Object?> get props => [books, continueItem, selectedBookId];
}

class LibraryError extends LibraryState {
  final String message;

  const LibraryError({required this.message});

  @override
  List<Object?> get props => [message];
}
