import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase(this.basePath);

  final String basePath;
  Database? _database;

  Database get database {
    final db = _database;
    if (db == null) {
      throw StateError('Database has not been initialized');
    }
    return db;
  }

  Future<void> init() async {
    final path = p.join(basePath, 'reading_app.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE books (
            id TEXT PRIMARY KEY,
            title TEXT,
            author TEXT,
            coverPath TEXT,
            content TEXT,
            createdAt INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE reading_progress (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            bookId TEXT,
            chapterId TEXT NULL,
            scrollOffset REAL,
            progressPercent REAL,
            fontSize REAL,
            lineHeight REAL,
            fontFamily TEXT,
            paragraphSpacing REAL,
            themeMode TEXT,
            lastUpdated INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE highlights (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            bookId TEXT,
            chapterId TEXT NULL,
            startIndex INTEGER,
            endIndex INTEGER,
            selectedText TEXT,
            colorHex TEXT,
            createdAt INTEGER,
            note TEXT NULL
          )
        ''');
        await db.execute('CREATE INDEX idx_highlights_book ON highlights(bookId)');
        await db.execute('CREATE INDEX idx_progress_book ON reading_progress(bookId)');
      },
    );
  }
}
