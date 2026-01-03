import '../entities/reading_progress.dart';

abstract class ReadingProgressRepository {
  Future<ReadingProgress?> getProgress(String bookId);
  Future<void> upsertProgress(ReadingProgress progress);
}
