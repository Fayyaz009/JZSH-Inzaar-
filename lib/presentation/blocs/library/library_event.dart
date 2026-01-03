part of 'library_bloc.dart';

abstract class LibraryEvent extends Equatable {
  const LibraryEvent();

  @override
  List<Object?> get props => [];
}

class LoadLibraryRequested extends LibraryEvent {}

class ContinueReadingRequested extends LibraryEvent {
  final String bookId;

  const ContinueReadingRequested(this.bookId);

  @override
  List<Object?> get props => [bookId];
}
