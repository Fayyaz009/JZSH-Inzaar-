import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final String id;
  final String title;
  final String author;
  final String coverPath;
  final String content;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.coverPath,
    required this.content,
  });

  @override
  List<Object?> get props => [id, title, author, coverPath, content];
}
