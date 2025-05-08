part of 'fetch_booking_with_barber_bloc.dart';


@immutable
abstract class FetchBookingWithBarberEvent{}

final class FetchBookingWithBarberRequest  extends FetchBookingWithBarberEvent{}

final class FetchBookingWithBarberFileterRequest extends FetchBookingWithBarberEvent{
  final String  filtering;

  FetchBookingWithBarberFileterRequest({required this.filtering});
}