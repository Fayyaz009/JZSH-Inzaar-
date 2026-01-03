import 'dart:math';
import 'package:flutter/material.dart';
import '../../domain/entities/highlight.dart';

class HighlightedText extends StatelessWidget {
  final String content;
  final List<Highlight> highlights;
  final TextStyle textStyle;
  final double paragraphSpacing;
  final ValueChanged<TextSelection>? onSelectionChanged;
  final ScrollController scrollController;

  const HighlightedText({
    super.key,
    required this.content,
    required this.highlights,
    required this.textStyle,
    required this.paragraphSpacing,
    required this.onSelectionChanged,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: SelectableText.rich(
        TextSpan(children: _buildSpans()),
        onSelectionChanged: (selection, _) => onSelectionChanged?.call(selection),
      ),
    );
  }

  List<TextSpan> _buildSpans() {
    final spans = <TextSpan>[];
    final sorted = [...highlights]
      ..sort((a, b) => a.startIndex.compareTo(b.startIndex));
    var index = 0;
    for (final highlight in sorted) {
      final start = max(0, min(highlight.startIndex, content.length));
      final end = max(start, min(highlight.endIndex, content.length));
      if (start > index) {
        spans.add(_baseSpan(content.substring(index, start)));
      }
      if (end > start) {
        spans.add(
          _baseSpan(
            content.substring(start, end),
            background: _fromHex(highlight.colorHex).withOpacity(0.6),
          ),
        );
      }
      index = end;
    }
    if (index < content.length) {
      spans.add(_baseSpan(content.substring(index)));
    }
    return spans;
  }

  TextSpan _baseSpan(String text, {Color? background}) {
    return TextSpan(
      text: text,
      style: textStyle.copyWith(
        height: textStyle.height ?? 1.6 + paragraphSpacing / 100,
        backgroundColor: background,
      ),
    );
  }

  Color _fromHex(String hex) {
    final cleaned = hex.replaceAll('#', '');
    return Color(int.parse('FF$cleaned', radix: 16));
  }
}
