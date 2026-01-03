import 'package:equatable/equatable.dart';

class ReadingProgress extends Equatable {
  final String bookId;
  final double scrollOffset;
  final double progressPercent;
  final double fontSize;
  final double lineHeight;
  final String fontFamily;
  final double paragraphSpacing;
  final String themeMode;
  final int lastUpdated;

  const ReadingProgress({
    required this.bookId,
    required this.scrollOffset,
    required this.progressPercent,
    required this.fontSize,
    required this.lineHeight,
    required this.fontFamily,
    required this.paragraphSpacing,
    required this.themeMode,
    required this.lastUpdated,
  });

  ReadingProgress copyWith({
    double? scrollOffset,
    double? progressPercent,
    double? fontSize,
    double? lineHeight,
    String? fontFamily,
    double? paragraphSpacing,
    String? themeMode,
    int? lastUpdated,
  }) {
    return ReadingProgress(
      bookId: bookId,
      scrollOffset: scrollOffset ?? this.scrollOffset,
      progressPercent: progressPercent ?? this.progressPercent,
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      fontFamily: fontFamily ?? this.fontFamily,
      paragraphSpacing: paragraphSpacing ?? this.paragraphSpacing,
      themeMode: themeMode ?? this.themeMode,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object?> get props => [
        bookId,
        scrollOffset,
        progressPercent,
        fontSize,
        lineHeight,
        fontFamily,
        paragraphSpacing,
        themeMode,
        lastUpdated,
      ];
}
