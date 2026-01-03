import '../entities/book.dart';
import '../repositories/book_repository.dart';

class GetBooks {
  GetBooks(this.repository);
  final BookRepository repository;

  Future<List<Book>> call() => repository.getBooks();
}
