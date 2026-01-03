import '../entities/book.dart';
import '../entities/highlight.dart';
import '../entities/reading_progress.dart';
import '../repositories/book_repository.dart';
import '../repositories/highlight_repository.dart';
import '../repositories/reading_progress_repository.dart';

class ReaderData {
  final Book book;
  final ReadingProgress? progress;
  final List<Highlight> highlights;

  ReaderData({required this.book, required this.progress, required this.highlights});
}

class LoadReaderData {
  LoadReaderData(this.bookRepository, this.progressRepository, this.highlightRepository);

  final BookRepository bookRepository;
  final ReadingProgressRepository progressRepository;
  final HighlightRepository highlightRepository;

  Future<ReaderData> call(String bookId) async {
    final book = await bookRepository.getBook(bookId);
    if (book == null) {
      throw StateError('Book not found');
    }
    final progress = await progressRepository.getProgress(bookId);
    final highlights = await highlightRepository.getHighlights(bookId: bookId);
    return ReaderData(book: book, progress: progress, highlights: highlights);
  }
}
