import 'package:equatable/equatable.dart';

abstract class ContentEvent extends Equatable {
  const ContentEvent();

  @override
  List<Object?> get props => [];
}

class LoadContent extends ContentEvent {
  const LoadContent();
}

class SelectModule extends ContentEvent {
  const SelectModule(this.moduleKey);

  final String moduleKey;

  @override
  List<Object?> get props => [moduleKey];
}
