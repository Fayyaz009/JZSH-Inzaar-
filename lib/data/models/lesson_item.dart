import 'package:equatable/equatable.dart';

class LessonItem extends Equatable {
  const LessonItem({
    required this.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.audioPath,
    required this.isPremium,
  });

  final String key;
  final String title;
  final String subtitle;
  final String imagePath;
  final String audioPath;
  final bool isPremium;

  @override
  List<Object?> get props => [key, title, subtitle, imagePath, audioPath, isPremium];
}
