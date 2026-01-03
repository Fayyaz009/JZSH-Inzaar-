import '../entities/book.dart';
import '../entities/reading_progress.dart';
import '../repositories/book_repository.dart';
import '../repositories/reading_progress_repository.dart';

class ContinueReadingItem {
  final Book book;
  final ReadingProgress progress;

  ContinueReadingItem({required this.book, required this.progress});
}

class GetContinueReading {
  GetContinueReading(this.progressRepository, this.bookRepository);

  final ReadingProgressRepository progressRepository;
  final BookRepository bookRepository;

  Future<ContinueReadingItem?> call(List<Book> books) async {
    ContinueReadingItem? latest;
    for (final book in books) {
      final progress = await progressRepository.getProgress(book.id);
      if (progress == null) continue;
      if (latest == null || progress.lastUpdated > latest.progress.lastUpdated) {
        latest = ContinueReadingItem(book: book, progress: progress);
      }
    }
    return latest;
  }
}
