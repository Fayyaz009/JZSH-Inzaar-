part of 'reader_bloc.dart';

class TypographySettings extends Equatable {
  final double fontSize;
  final double lineHeight;
  final String fontFamily;
  final double paragraphSpacing;

  const TypographySettings({
    required this.fontSize,
    required this.lineHeight,
    required this.fontFamily,
    required this.paragraphSpacing,
  });

  factory TypographySettings.fromProgress(ReadingProgress progress) {
    return TypographySettings(
      fontSize: progress.fontSize,
      lineHeight: progress.lineHeight,
      fontFamily: progress.fontFamily,
      paragraphSpacing: progress.paragraphSpacing,
    );
  }

  TypographySettings copyWith({
    double? fontSize,
    double? lineHeight,
    String? fontFamily,
    double? paragraphSpacing,
  }) {
    return TypographySettings(
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      fontFamily: fontFamily ?? this.fontFamily,
      paragraphSpacing: paragraphSpacing ?? this.paragraphSpacing,
    );
  }

  @override
  List<Object?> get props => [fontSize, lineHeight, fontFamily, paragraphSpacing];
}

abstract class ReaderState extends Equatable {
  const ReaderState();

  @override
  List<Object?> get props => [];
}

class ReaderInitial extends ReaderState {}

class ReaderLoading extends ReaderState {}

class ReaderReady extends ReaderState {
  final Book book;
  final String themeMode;
  final TypographySettings typographySettings;
  final double scrollOffset;
  final double progressPercent;
  final List<Highlight> highlights;
  final int? pendingJumpHighlightId;

  const ReaderReady({
    required this.book,
    required this.themeMode,
    required this.typographySettings,
    required this.scrollOffset,
    required this.progressPercent,
    required this.highlights,
    required this.pendingJumpHighlightId,
  });

  ReaderReady copyWith({
    String? themeMode,
    TypographySettings? typographySettings,
    double? scrollOffset,
    double? progressPercent,
    List<Highlight>? highlights,
    int? pendingJumpHighlightId,
  }) {
    return ReaderReady(
      book: book,
      themeMode: themeMode ?? this.themeMode,
      typographySettings: typographySettings ?? this.typographySettings,
      scrollOffset: scrollOffset ?? this.scrollOffset,
      progressPercent: progressPercent ?? this.progressPercent,
      highlights: highlights ?? this.highlights,
      pendingJumpHighlightId: pendingJumpHighlightId,
    );
  }

  @override
  List<Object?> get props => [
        book,
        themeMode,
        typographySettings,
        scrollOffset,
        progressPercent,
        highlights,
        pendingJumpHighlightId,
      ];
}

class ReaderError extends ReaderState {
  final String message;

  const ReaderError({required this.message});

  @override
  List<Object?> get props => [message];
}
