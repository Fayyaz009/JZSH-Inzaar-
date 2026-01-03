import 'package:flutter/material.dart';

class HighlightActionsSheet extends StatelessWidget {
  final VoidCallback onCopy;
  final ValueChanged<String> onColorSelected;

  const HighlightActionsSheet({
    super.key,
    required this.onCopy,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Highlight', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: [
                _colorDot('#F6E58D'),
                _colorDot('#A3E4D7'),
                _colorDot('#AED6F1'),
                _colorDot('#F5B7B1'),
              ],
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: onCopy,
              icon: const Icon(Icons.copy_rounded),
              label: const Text('Copy'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _colorDot(String hex) {
    final color = _fromHex(hex);
    return GestureDetector(
      onTap: () => onColorSelected(hex),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black12),
        ),
      ),
    );
  }

  Color _fromHex(String hex) {
    final cleaned = hex.replaceAll('#', '');
    return Color(int.parse('FF$cleaned', radix: 16));
  }
}
