import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/content_repository.dart';
import 'content_event.dart';
import 'content_state.dart';

class ContentBloc extends Bloc<ContentEvent, ContentState> {
  ContentBloc({required this.contentRepository}) : super(ContentState.initial()) {
    on<LoadContent>(_onLoadContent);
    on<SelectModule>(_onSelectModule);
  }

  final ContentRepository contentRepository;

  Future<void> _onLoadContent(
    LoadContent event,
    Emitter<ContentState> emit,
  ) async {
    emit(state.copyWith(status: ContentStatus.loading));
    final modules = contentRepository.getModules();
    final rhymes = contentRepository.getRhymes();
    emit(state.copyWith(
      status: ContentStatus.loaded,
      modules: modules,
      rhymes: rhymes,
    ));
  }

  void _onSelectModule(
    SelectModule event,
    Emitter<ContentState> emit,
  ) {
    emit(state.copyWith(selectedModuleKey: event.moduleKey));
  }
}
