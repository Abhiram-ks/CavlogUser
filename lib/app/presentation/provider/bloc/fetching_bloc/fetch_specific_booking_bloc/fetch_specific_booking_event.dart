part of 'fetch_specific_booking_bloc.dart';



abstract class FetchSpecificBookingEvent {}
final class FetchSpecificBookingRequest extends FetchSpecificBookingEvent{
  final String docId;
  
  FetchSpecificBookingRequest({required this.docId});
}
