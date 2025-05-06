part of 'wallet_payment_bloc.dart';


@immutable
abstract class WalletPaymentState{}

final class WalletPaymentInitial extends WalletPaymentState {}
final class WalletPaymentLoading extends WalletPaymentState {}
final class WalletPaymentSlotNotAvalbale extends WalletPaymentState{}
final class WalletPaymntSlotAvalable extends WalletPaymentState {}
final class WalletPaymentSuccess extends WalletPaymentState {}
final class WalletPaymentFailure extends WalletPaymentState {
  final String errorMessage;
   
  WalletPaymentFailure(this.errorMessage);
}
