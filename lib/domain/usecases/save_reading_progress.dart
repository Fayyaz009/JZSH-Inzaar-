import '../entities/reading_progress.dart';
import '../repositories/reading_progress_repository.dart';

class SaveReadingProgress {
  SaveReadingProgress(this.repository);

  final ReadingProgressRepository repository;

  Future<void> call(ReadingProgress progress) {
    return repository.upsertProgress(progress);
  }
}
