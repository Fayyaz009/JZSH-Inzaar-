import '../db/app_database.dart';
import '../models/highlight_model.dart';

class HighlightLocalDataSource {
  HighlightLocalDataSource(this.database);

  final AppDatabase database;

  Future<List<HighlightModel>> getHighlights({String? bookId}) async {
    final db = database.database;
    final results = await db.query(
      'highlights',
      where: bookId != null ? 'bookId = ?' : null,
      whereArgs: bookId != null ? [bookId] : null,
      orderBy: 'createdAt DESC',
    );
    return results.map(HighlightModel.fromMap).toList();
  }

  Future<int> addHighlight(HighlightModel highlight) async {
    final db = database.database;
    return db.insert('highlights', highlight.toMap());
  }

  Future<void> updateHighlight(HighlightModel highlight) async {
    final db = database.database;
    await db.update(
      'highlights',
      highlight.toMap(),
      where: 'id = ?',
      whereArgs: [highlight.id],
    );
  }

  Future<void> deleteHighlight(int id) async {
    final db = database.database;
    await db.delete('highlights', where: 'id = ?', whereArgs: [id]);
  }

  Future<HighlightModel?> getHighlight(int id) async {
    final db = database.database;
    final results = await db.query('highlights', where: 'id = ?', whereArgs: [id]);
    if (results.isEmpty) return null;
    return HighlightModel.fromMap(results.first);
  }
}
