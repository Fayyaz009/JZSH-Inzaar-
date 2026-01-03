import 'package:equatable/equatable.dart';

class ProgressEntry extends Equatable {
  const ProgressEntry({
    required this.id,
    required this.moduleKey,
    required this.itemKey,
    required this.completed,
    required this.updatedAt,
  });

  final String id;
  final String moduleKey;
  final String itemKey;
  final bool completed;
  final int updatedAt;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'moduleKey': moduleKey,
      'itemKey': itemKey,
      'completed': completed ? 1 : 0,
      'updatedAt': updatedAt,
    };
  }

  factory ProgressEntry.fromMap(Map<String, Object?> map) {
    return ProgressEntry(
      id: map['id'] as String,
      moduleKey: map['moduleKey'] as String,
      itemKey: map['itemKey'] as String,
      completed: (map['completed'] as int) == 1,
      updatedAt: map['updatedAt'] as int,
    );
  }

  @override
  List<Object?> get props => [id, moduleKey, itemKey, completed, updatedAt];
}
