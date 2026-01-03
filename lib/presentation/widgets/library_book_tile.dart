import 'package:flutter/material.dart';
import '../../domain/entities/book.dart';

class LibraryBookTile extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;

  const LibraryBookTile({super.key, required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(book.title),
        subtitle: Text(book.author),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
