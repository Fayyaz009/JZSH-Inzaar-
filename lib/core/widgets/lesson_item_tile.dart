import 'package:flutter/material.dart';

class LessonItemTile extends StatelessWidget {
  const LessonItemTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.locked,
    required this.completed,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool locked;
  final bool completed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              if (locked)
                const Icon(Icons.lock, color: Colors.redAccent)
              else if (completed)
                const Icon(Icons.star, color: Colors.amber)
              else
                const Icon(Icons.play_circle_fill, color: Colors.green),
            ],
          ),
        ),
      ),
    );
  }
}
