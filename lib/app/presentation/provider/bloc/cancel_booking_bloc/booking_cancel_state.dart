part of 'booking_cancel_bloc.dart';

abstract class BookingCancelState {}

final class BookingCancelInitial extends BookingCancelState {}
final class BookingOTPMaching extends BookingCancelState {}
final class BookingOPTNotMaching extends BookingCancelState {}


final class BookingCancelLoading extends BookingCancelState {}
final class BookingCancelSuccess extends BookingCancelState {}
final class BookingCancelWithoutRefundSuccess extends BookingCancelState {}
final class BookingCancelFailure extends BookingCancelState {
  final String errorMessage;

  BookingCancelFailure(this.errorMessage);
}
