import 'package:flutter/material.dart';
import '../../domain/usecases/get_continue_reading.dart';

class ContinueReadingCard extends StatelessWidget {
  final ContinueReadingItem item;
  final VoidCallback onContinue;

  const ContinueReadingCard({super.key, required this.item, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final progress = (item.progress.progressPercent * 100).clamp(0, 100).toStringAsFixed(1);
    final updated = DateTime.fromMillisecondsSinceEpoch(item.progress.lastUpdated);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.12),
            Theme.of(context).colorScheme.secondary.withOpacity(0.08),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Continue Reading', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Text(item.book.title, style: Theme.of(context).textTheme.titleLarge),
          Text(item.book.author, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 12),
          Text('Progress: $progress%'),
          Text('Last opened: ${_formatDate(updated)}'),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: onContinue,
              child: const Text('Continue'),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
