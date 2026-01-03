import 'package:sqflite/sqflite.dart';

import '../../core/db/app_database.dart';
import '../../core/db/tables.dart';
import '../models/progress.dart';

class ProgressRepository {
  ProgressRepository({required this.database});

  final AppDatabase database;

  Future<List<ProgressEntry>> getAllProgress() async {
    final rows = await database.database.query(AppTables.progress);
    return rows.map(ProgressEntry.fromMap).toList();
  }

  Future<void> upsertProgress(ProgressEntry entry) async {
    await database.database.insert(
      AppTables.progress,
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> resetProgress() async {
    await database.database.delete(AppTables.progress);
  }
}
