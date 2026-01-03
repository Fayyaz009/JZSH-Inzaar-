import 'package:equatable/equatable.dart';

class Highlight extends Equatable {
  final int id;
  final String bookId;
  final int startIndex;
  final int endIndex;
  final String selectedText;
  final String colorHex;
  final int createdAt;
  final String? note;

  const Highlight({
    required this.id,
    required this.bookId,
    required this.startIndex,
    required this.endIndex,
    required this.selectedText,
    required this.colorHex,
    required this.createdAt,
    this.note,
  });

  Highlight copyWith({
    String? colorHex,
    String? note,
  }) {
    return Highlight(
      id: id,
      bookId: bookId,
      startIndex: startIndex,
      endIndex: endIndex,
      selectedText: selectedText,
      colorHex: colorHex ?? this.colorHex,
      createdAt: createdAt,
      note: note ?? this.note,
    );
  }

  @override
  List<Object?> get props => [
        id,
        bookId,
        startIndex,
        endIndex,
        selectedText,
        colorHex,
        createdAt,
        note,
      ];
}
