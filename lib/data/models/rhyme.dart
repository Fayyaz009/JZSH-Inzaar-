import 'package:equatable/equatable.dart';

class Rhyme extends Equatable {
  const Rhyme({
    required this.key,
    required this.title,
    required this.audioPath,
    required this.isPremium,
  });

  final String key;
  final String title;
  final String audioPath;
  final bool isPremium;

  @override
  List<Object?> get props => [key, title, audioPath, isPremium];
}
