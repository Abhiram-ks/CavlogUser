part of 'fetch_booking_with_barber_bloc.dart';


@immutable
abstract class FetchBookingWithBarberState{}

final class FetchBookingWithBarberInitial extends FetchBookingWithBarberState {}
final class FetchBookingWithBarberLoading extends FetchBookingWithBarberState {}
final class FetchBookingWithBarberEmpty extends FetchBookingWithBarberState {}
final class FetchBookingWithBarberLoaded extends FetchBookingWithBarberState {
  final List<BookingWithBarberModel> combo;

  FetchBookingWithBarberLoaded({required this.combo});
}


final class FetchBookingWithBarberFailure extends FetchBookingWithBarberState {
  final String errorMessage;

  FetchBookingWithBarberFailure(this.errorMessage);
}