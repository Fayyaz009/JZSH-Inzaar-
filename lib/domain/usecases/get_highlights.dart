import '../entities/book.dart';
import '../entities/highlight.dart';
import '../repositories/book_repository.dart';
import '../repositories/highlight_repository.dart';

class BookHighlightsGroup {
  final Book book;
  final List<Highlight> highlights;

  BookHighlightsGroup({required this.book, required this.highlights});
}

class GetHighlights {
  GetHighlights(this.highlightRepository, this.bookRepository);

  final HighlightRepository highlightRepository;
  final BookRepository bookRepository;

  Future<List<BookHighlightsGroup>> call({String? bookId}) async {
    final books = await bookRepository.getBooks();
    final highlights = await highlightRepository.getHighlights(bookId: bookId);
    final groups = <BookHighlightsGroup>[];
    for (final book in books) {
      final items = highlights.where((h) => h.bookId == book.id).toList();
      if (items.isEmpty) continue;
      groups.add(BookHighlightsGroup(book: book, highlights: items));
    }
    return groups;
  }
}
