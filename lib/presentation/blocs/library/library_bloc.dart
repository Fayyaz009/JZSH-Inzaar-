import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/book.dart';
import '../../../domain/usecases/get_books.dart';
import '../../../domain/usecases/get_continue_reading.dart';

part 'library_event.dart';
part 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  LibraryBloc({required this.getBooks, required this.getContinueReading})
      : super(LibraryInitial()) {
    on<LoadLibraryRequested>(_onLoadLibraryRequested);
    on<ContinueReadingRequested>(_onContinueReadingRequested);
  }

  final GetBooks getBooks;
  final GetContinueReading getContinueReading;

  Future<void> _onLoadLibraryRequested(
    LoadLibraryRequested event,
    Emitter<LibraryState> emit,
  ) async {
    emit(LibraryLoading());
    try {
      final books = await getBooks();
      final continueItem = await getContinueReading(books);
      emit(LibraryLoaded(books: books, continueItem: continueItem));
    } catch (error) {
      emit(LibraryError(message: error.toString()));
    }
  }

  Future<void> _onContinueReadingRequested(
    ContinueReadingRequested event,
    Emitter<LibraryState> emit,
  ) async {
    if (state is! LibraryLoaded) return;
    final current = state as LibraryLoaded;
    emit(current.copyWith(selectedBookId: event.bookId));
  }
}
