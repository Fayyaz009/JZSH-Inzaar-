import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/book_model.dart';

class BookLocalDataSource {
  Future<List<BookModel>> loadBooks() async {
    final raw = await rootBundle.loadString('assets/books.json');
    final jsonList = jsonDecode(raw) as List<dynamic>;
    return jsonList
        .map((item) => BookModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
