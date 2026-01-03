import 'package:equatable/equatable.dart';

import '../../data/models/module.dart';
import '../../data/models/rhyme.dart';

enum ContentStatus { initial, loading, loaded }

class ContentState extends Equatable {
  const ContentState({
    required this.status,
    required this.modules,
    required this.rhymes,
    required this.selectedModuleKey,
  });

  final ContentStatus status;
  final List<Module> modules;
  final List<Rhyme> rhymes;
  final String selectedModuleKey;

  ContentState copyWith({
    ContentStatus? status,
    List<Module>? modules,
    List<Rhyme>? rhymes,
    String? selectedModuleKey,
  }) {
    return ContentState(
      status: status ?? this.status,
      modules: modules ?? this.modules,
      rhymes: rhymes ?? this.rhymes,
      selectedModuleKey: selectedModuleKey ?? this.selectedModuleKey,
    );
  }

  @override
  List<Object?> get props => [status, modules, rhymes, selectedModuleKey];

  factory ContentState.initial() => const ContentState(
        status: ContentStatus.initial,
        modules: [],
        rhymes: [],
        selectedModuleKey: '',
      );
}
