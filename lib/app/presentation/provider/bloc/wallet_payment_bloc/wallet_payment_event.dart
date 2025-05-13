part of 'wallet_payment_bloc.dart';


@immutable
abstract class WalletPaymentEvent {}
final class WalletPaymentCheckSlots extends WalletPaymentEvent{
  final String barberId;
  final List<SlotModel> selectedSlots;

  WalletPaymentCheckSlots({required this.barberId, required this.selectedSlots});
}


final class WalletPaymentRequest extends WalletPaymentEvent {
  final String barberId;
  final List<SlotModel> selectedSlots;
  final List<Map<String, dynamic>> selectedServices;
  final double platformFee;
  final double bookingAmount;
  final String invoiceId;

  WalletPaymentRequest({required this.invoiceId,required this.selectedSlots,required this.selectedServices,required this.bookingAmount, required this.barberId, required this.platformFee});
}
