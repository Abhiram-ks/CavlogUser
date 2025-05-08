part of 'fetch_specific_booking_bloc.dart';

abstract class FetchSpecificBookingState{}

final class FetchSpecificBookingInitial extends FetchSpecificBookingState {}
final class FetchSpecificBookingLoading extends FetchSpecificBookingState {}
final class FetchSpecificBookingLoaded extends FetchSpecificBookingState {
  final BookingModel booking;

  FetchSpecificBookingLoaded({required this.booking});
}
final class FetchSpecificBookingFailure extends FetchSpecificBookingState {
  final String errorMessage;

  FetchSpecificBookingFailure(this.errorMessage);
}
