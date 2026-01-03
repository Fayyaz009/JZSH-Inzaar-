import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/progress.dart';
import '../../data/repositories/progress_repository.dart';
import 'progress_event.dart';
import 'progress_state.dart';

class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  ProgressBloc({required this.progressRepository}) : super(ProgressState.initial()) {
    on<LoadProgress>(_onLoadProgress);
    on<MarkItemCompleted>(_onMarkItemCompleted);
    on<ResetProgress>(_onResetProgress);
  }

  final ProgressRepository progressRepository;

  Future<void> _onLoadProgress(
    LoadProgress event,
    Emitter<ProgressState> emit,
  ) async {
    emit(state.copyWith(status: ProgressStatus.loading));
    final entries = await progressRepository.getAllProgress();
    final map = {for (final entry in entries) entry.id: entry};
    emit(state.copyWith(status: ProgressStatus.loaded, entries: map));
  }

  Future<void> _onMarkItemCompleted(
    MarkItemCompleted event,
    Emitter<ProgressState> emit,
  ) async {
    final id = '${event.moduleKey}_${event.itemKey}';
    final entry = ProgressEntry(
      id: id,
      moduleKey: event.moduleKey,
      itemKey: event.itemKey,
      completed: true,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
    await progressRepository.upsertProgress(entry);
    final updated = Map<String, ProgressEntry>.from(state.entries)..[id] = entry;
    emit(state.copyWith(entries: updated));
  }

  Future<void> _onResetProgress(
    ResetProgress event,
    Emitter<ProgressState> emit,
  ) async {
    await progressRepository.resetProgress();
    emit(state.copyWith(entries: {}));
  }
}
