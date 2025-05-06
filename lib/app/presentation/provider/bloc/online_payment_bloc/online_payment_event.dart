part of 'online_payment_bloc.dart';

sealed class OnlinePaymentEvent {}

final class OnlinePaymentCheckSlots extends OnlinePaymentEvent{
  final String barberId;
  final List<SlotModel> selectedSlots;

  OnlinePaymentCheckSlots({required this.barberId, required this.selectedSlots});
}


final class OnlinePaymentRequest extends OnlinePaymentEvent{
  final String barberId;
  final List<SlotModel> selectedSlots;
  final List<Map<String, dynamic>> selectedServices;
  final double platformFee;
  final double bookingAmount;

  OnlinePaymentRequest({required this.barberId,required this.selectedSlots, required this.selectedServices,required this.platformFee,required this.bookingAmount});
}
