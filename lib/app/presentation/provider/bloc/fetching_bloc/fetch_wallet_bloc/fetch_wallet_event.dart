part of 'fetch_wallet_bloc.dart';

@immutable
abstract class FetchWalletEvent extends Equatable {
  const FetchWalletEvent();
}

class FetchWalletRequest extends FetchWalletEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class FetchWalletUpdated extends FetchWalletEvent {
  final WalletModel? wallet;

  const FetchWalletUpdated(this.wallet);

  @override
  List<Object?> get props => [wallet];
}
