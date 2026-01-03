import '../entities/book.dart';

abstract class BookRepository {
  Future<List<Book>> getBooks();
  Future<Book?> getBook(String id);
}
