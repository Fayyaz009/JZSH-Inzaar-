import 'package:equatable/equatable.dart';

import 'lesson_item.dart';

class Module extends Equatable {
  const Module({
    required this.key,
    required this.title,
    required this.subtitle,
    required this.colorValue,
    required this.items,
    required this.isPremiumModule,
  });

  final String key;
  final String title;
  final String subtitle;
  final int colorValue;
  final List<LessonItem> items;
  final bool isPremiumModule;

  @override
  List<Object?> get props => [key, title, subtitle, colorValue, items, isPremiumModule];
}
