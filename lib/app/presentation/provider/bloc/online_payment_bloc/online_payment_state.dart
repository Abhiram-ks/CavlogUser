part of 'online_payment_bloc.dart';

@immutable
abstract class OnlinePaymentState{}

final class OnlinePaymentInitial extends OnlinePaymentState {}
final class OnlinePaymntSlotAvalable extends OnlinePaymentState {}
final class OnlinePaymentLoading extends OnlinePaymentState {}
final class OnlinePaymentSlogNotAvalable extends OnlinePaymentState {}
final class OnlinePaymentSuccess extends OnlinePaymentState {}
final class OnlinePaymentFailure extends OnlinePaymentState {
  final String errorMessage;

  OnlinePaymentFailure(this.errorMessage);
}
