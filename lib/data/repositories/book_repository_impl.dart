import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository.dart';
import '../datasources/book_local_data_source.dart';

class BookRepositoryImpl implements BookRepository {
  BookRepositoryImpl(this.dataSource);

  final BookLocalDataSource dataSource;
  List<Book>? _cache;

  @override
  Future<List<Book>> getBooks() async {
    _cache ??= await dataSource.loadBooks();
    return _cache!;
  }

  @override
  Future<Book?> getBook(String id) async {
    final books = await getBooks();
    try {
      return books.firstWhere((book) => book.id == id);
    } catch (_) {
      return null;
    }
  }
}
