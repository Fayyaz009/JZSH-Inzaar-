import 'package:equatable/equatable.dart';

import '../../data/models/settings.dart';

enum PremiumStatus { initial, loading, ready }

class PremiumState extends Equatable {
  const PremiumState({
    required this.status,
    required this.settings,
  });

  final PremiumStatus status;
  final SettingsData settings;

  PremiumState copyWith({
    PremiumStatus? status,
    SettingsData? settings,
  }) {
    return PremiumState(
      status: status ?? this.status,
      settings: settings ?? this.settings,
    );
  }

  @override
  List<Object?> get props => [status, settings];

  factory PremiumState.initial() => const PremiumState(
        status: PremiumStatus.initial,
        settings: SettingsData(isPremium: false, musicOn: true, sfxOn: true),
      );
}
