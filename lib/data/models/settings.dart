import 'package:equatable/equatable.dart';

class SettingsData extends Equatable {
  const SettingsData({
    required this.isPremium,
    required this.musicOn,
    required this.sfxOn,
  });

  final bool isPremium;
  final bool musicOn;
  final bool sfxOn;

  SettingsData copyWith({
    bool? isPremium,
    bool? musicOn,
    bool? sfxOn,
  }) {
    return SettingsData(
      isPremium: isPremium ?? this.isPremium,
      musicOn: musicOn ?? this.musicOn,
      sfxOn: sfxOn ?? this.sfxOn,
    );
  }

  @override
  List<Object?> get props => [isPremium, musicOn, sfxOn];
}
