import 'package:equatable/equatable.dart';

class ProgressEvent extends Equatable {
  const ProgressEvent();

  @override
  List<Object?> get props => [];
}

class LoadProgress extends ProgressEvent {
  const LoadProgress();
}

class MarkItemCompleted extends ProgressEvent {
  const MarkItemCompleted({
    required this.moduleKey,
    required this.itemKey,
  });

  final String moduleKey;
  final String itemKey;

  @override
  List<Object?> get props => [moduleKey, itemKey];
}

class ResetProgress extends ProgressEvent {
  const ResetProgress();
}
