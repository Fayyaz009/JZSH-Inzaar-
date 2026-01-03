import '../../domain/entities/highlight.dart';

class HighlightModel extends Highlight {
  const HighlightModel({
    required super.id,
    required super.bookId,
    required super.startIndex,
    required super.endIndex,
    required super.selectedText,
    required super.colorHex,
    required super.createdAt,
    super.note,
  });

  factory HighlightModel.fromMap(Map<String, dynamic> map) {
    return HighlightModel(
      id: map['id'] as int,
      bookId: map['bookId'] as String,
      startIndex: map['startIndex'] as int,
      endIndex: map['endIndex'] as int,
      selectedText: map['selectedText'] as String,
      colorHex: map['colorHex'] as String,
      createdAt: map['createdAt'] as int,
      note: map['note'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookId': bookId,
      'startIndex': startIndex,
      'endIndex': endIndex,
      'selectedText': selectedText,
      'colorHex': colorHex,
      'createdAt': createdAt,
      'note': note,
    };
  }
}
