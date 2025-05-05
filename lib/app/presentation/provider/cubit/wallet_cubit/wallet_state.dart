part of 'wallet_cubit.dart';


@immutable
abstract class WalletState {}

class WalletInitial extends WalletState {}

class WalletUpdating extends WalletState {}

class WalletUpdated extends WalletState {
  final String labelText;
  WalletUpdated({required this.labelText});
}

class WalletError extends WalletState {
  final String message;
  WalletError(this.message);
}
