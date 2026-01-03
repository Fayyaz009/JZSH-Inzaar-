import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/settings.dart';
import '../../data/repositories/premium_repository.dart';
import 'premium_event.dart';
import 'premium_state.dart';

class PremiumBloc extends Bloc<PremiumEvent, PremiumState> {
  PremiumBloc({required this.premiumRepository}) : super(PremiumState.initial()) {
    on<LoadPremium>(_onLoadPremium);
    on<UnlockPremium>(_onUnlockPremium);
    on<RestorePurchase>(_onRestorePurchase);
    on<ToggleMusic>(_onToggleMusic);
    on<ToggleSfx>(_onToggleSfx);
  }

  final PremiumRepository premiumRepository;

  Future<void> _onLoadPremium(
    LoadPremium event,
    Emitter<PremiumState> emit,
  ) async {
    emit(state.copyWith(status: PremiumStatus.loading));
    final settings = await premiumRepository.loadSettings();
    emit(state.copyWith(status: PremiumStatus.ready, settings: settings));
  }

  Future<void> _onUnlockPremium(
    UnlockPremium event,
    Emitter<PremiumState> emit,
  ) async {
    await premiumRepository.setPremium(true);
    final settings = state.settings.copyWith(isPremium: true);
    emit(state.copyWith(settings: settings));
  }

  Future<void> _onRestorePurchase(
    RestorePurchase event,
    Emitter<PremiumState> emit,
  ) async {
    await premiumRepository.setPremium(true);
    final settings = state.settings.copyWith(isPremium: true);
    emit(state.copyWith(settings: settings));
  }

  Future<void> _onToggleMusic(
    ToggleMusic event,
    Emitter<PremiumState> emit,
  ) async {
    final newValue = !state.settings.musicOn;
    await premiumRepository.setMusic(newValue);
    emit(state.copyWith(settings: state.settings.copyWith(musicOn: newValue)));
  }

  Future<void> _onToggleSfx(
    ToggleSfx event,
    Emitter<PremiumState> emit,
  ) async {
    final newValue = !state.settings.sfxOn;
    await premiumRepository.setSfx(newValue);
    emit(state.copyWith(settings: state.settings.copyWith(sfxOn: newValue)));
  }
}
