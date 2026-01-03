import '../../domain/entities/reading_progress.dart';
import '../../domain/repositories/reading_progress_repository.dart';
import '../datasources/reading_progress_local_data_source.dart';
import '../models/reading_progress_model.dart';

class ReadingProgressRepositoryImpl implements ReadingProgressRepository {
  ReadingProgressRepositoryImpl(this.dataSource);

  final ReadingProgressLocalDataSource dataSource;

  @override
  Future<ReadingProgress?> getProgress(String bookId) async {
    return dataSource.getProgress(bookId);
  }

  @override
  Future<void> upsertProgress(ReadingProgress progress) async {
    final model = ReadingProgressModel(
      bookId: progress.bookId,
      scrollOffset: progress.scrollOffset,
      progressPercent: progress.progressPercent,
      fontSize: progress.fontSize,
      lineHeight: progress.lineHeight,
      fontFamily: progress.fontFamily,
      paragraphSpacing: progress.paragraphSpacing,
      themeMode: progress.themeMode,
      lastUpdated: progress.lastUpdated,
    );
    await dataSource.upsertProgress(model);
  }
}
