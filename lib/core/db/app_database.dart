import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'tables.dart';

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();
  Database? _database;

  Future<void> initialize() async {
    if (_database != null) {
      return;
    }
    final directory = await getApplicationDocumentsDirectory();
    final path = p.join(directory.path, 'kids_learning.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Database get database {
    final db = _database;
    if (db == null) {
      throw StateError('Database has not been initialized');
    }
    return db;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${AppTables.settings}(
        id INTEGER PRIMARY KEY,
        isPremium INTEGER NOT NULL,
        musicOn INTEGER NOT NULL,
        sfxOn INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE ${AppTables.progress}(
        id TEXT PRIMARY KEY,
        moduleKey TEXT NOT NULL,
        itemKey TEXT NOT NULL,
        completed INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL
      )
    ''');

    await db.insert(AppTables.settings, {
      'id': 1,
      'isPremium': 0,
      'musicOn': 1,
      'sfxOn': 1,
    });
  }
}
