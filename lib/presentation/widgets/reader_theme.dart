import 'package:flutter/material.dart';

class ReaderTheme {
  final Color background;
  final Color text;

  const ReaderTheme({required this.background, required this.text});

  static ReaderTheme fromMode(String mode) {
    switch (mode) {
      case 'dark':
        return const ReaderTheme(background: Color(0xFF111111), text: Color(0xFFF5F5F5));
      case 'sepia':
        return const ReaderTheme(background: Color(0xFFF6F0E3), text: Color(0xFF3E2C1A));
      default:
        return const ReaderTheme(background: Color(0xFFFDFDFB), text: Color(0xFF1C1B1F));
    }
  }
}
