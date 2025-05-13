part of 'booking_cancel_bloc.dart';

@immutable
abstract class BookingCancelEvent{}

final class BookingOTPChecking extends BookingCancelEvent{
  final String inputOTP;
  final String bookingOTP;

   BookingOTPChecking({required this.bookingOTP, required this.inputOTP});
}

final class BookingCancelRequest extends BookingCancelEvent{
  final BookingModel model;

  BookingCancelRequest(this.model);
}