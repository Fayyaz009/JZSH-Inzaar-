import 'package:equatable/equatable.dart';

import '../../data/models/progress.dart';

enum ProgressStatus { initial, loading, loaded }

class ProgressState extends Equatable {
  const ProgressState({
    required this.status,
    required this.entries,
  });

  final ProgressStatus status;
  final Map<String, ProgressEntry> entries;

  ProgressState copyWith({
    ProgressStatus? status,
    Map<String, ProgressEntry>? entries,
  }) {
    return ProgressState(
      status: status ?? this.status,
      entries: entries ?? this.entries,
    );
  }

  @override
  List<Object?> get props => [status, entries];

  factory ProgressState.initial() => const ProgressState(
        status: ProgressStatus.initial,
        entries: {},
      );
}
