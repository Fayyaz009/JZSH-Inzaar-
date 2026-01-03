import 'package:sqflite/sqflite.dart';
import '../db/app_database.dart';
import '../models/reading_progress_model.dart';

class ReadingProgressLocalDataSource {
  ReadingProgressLocalDataSource(this.database);

  final AppDatabase database;

  Future<ReadingProgressModel?> getProgress(String bookId) async {
    final db = database.database;
    final results = await db.query(
      'reading_progress',
      where: 'bookId = ?',
      whereArgs: [bookId],
      limit: 1,
    );
    if (results.isEmpty) return null;
    return ReadingProgressModel.fromMap(results.first);
  }

  Future<void> upsertProgress(ReadingProgressModel progress) async {
    final db = database.database;
    final existing = await db.query(
      'reading_progress',
      where: 'bookId = ?',
      whereArgs: [progress.bookId],
      limit: 1,
    );
    if (existing.isEmpty) {
      await db.insert('reading_progress', progress.toMap());
    } else {
      await db.update(
        'reading_progress',
        progress.toMap(),
        where: 'bookId = ?',
        whereArgs: [progress.bookId],
      );
    }
  }
}
