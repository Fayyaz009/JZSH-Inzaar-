import '../../domain/entities/reading_progress.dart';

class ReadingProgressModel extends ReadingProgress {
  const ReadingProgressModel({
    required super.bookId,
    required super.scrollOffset,
    required super.progressPercent,
    required super.fontSize,
    required super.lineHeight,
    required super.fontFamily,
    required super.paragraphSpacing,
    required super.themeMode,
    required super.lastUpdated,
  });

  factory ReadingProgressModel.fromMap(Map<String, dynamic> map) {
    return ReadingProgressModel(
      bookId: map['bookId'] as String,
      scrollOffset: (map['scrollOffset'] as num?)?.toDouble() ?? 0,
      progressPercent: (map['progressPercent'] as num?)?.toDouble() ?? 0,
      fontSize: (map['fontSize'] as num?)?.toDouble() ?? 18,
      lineHeight: (map['lineHeight'] as num?)?.toDouble() ?? 1.6,
      fontFamily: (map['fontFamily'] as String?) ?? 'Merriweather',
      paragraphSpacing: (map['paragraphSpacing'] as num?)?.toDouble() ?? 12,
      themeMode: (map['themeMode'] as String?) ?? 'light',
      lastUpdated: map['lastUpdated'] as int? ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookId': bookId,
      'scrollOffset': scrollOffset,
      'progressPercent': progressPercent,
      'fontSize': fontSize,
      'lineHeight': lineHeight,
      'fontFamily': fontFamily,
      'paragraphSpacing': paragraphSpacing,
      'themeMode': themeMode,
      'lastUpdated': lastUpdated,
    };
  }
}
