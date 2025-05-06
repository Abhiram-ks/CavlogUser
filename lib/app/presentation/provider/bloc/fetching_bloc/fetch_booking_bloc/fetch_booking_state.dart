part of 'fetch_booking_bloc.dart';


@immutable
abstract class FetchBookingState {}

final class FetchBookingInitial extends FetchBookingState {}
final class FetchBookingLoading extends FetchBookingState {}
final class FetchBookingEmpty extends FetchBookingState {}
final class FetchBookingSuccess extends FetchBookingState {
  final List<BookingModel> bookings;

  FetchBookingSuccess({required this.bookings});
}
final class FetchBookingFailure extends FetchBookingState {
  final String errorMessage;

  FetchBookingFailure(this.errorMessage);
}
