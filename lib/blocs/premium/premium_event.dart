import 'package:equatable/equatable.dart';

abstract class PremiumEvent extends Equatable {
  const PremiumEvent();

  @override
  List<Object?> get props => [];
}

class LoadPremium extends PremiumEvent {
  const LoadPremium();
}

class UnlockPremium extends PremiumEvent {
  const UnlockPremium();
}

class RestorePurchase extends PremiumEvent {
  const RestorePurchase();
}

class ToggleMusic extends PremiumEvent {
  const ToggleMusic();
}

class ToggleSfx extends PremiumEvent {
  const ToggleSfx();
}
