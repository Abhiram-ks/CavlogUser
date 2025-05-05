part of 'fetch_slots_specificdate_bloc.dart';

@immutable
abstract class FetchSlotsSpecificdateEvent {}

final class FetchSlotsSpecificdateRequst extends FetchSlotsSpecificdateEvent {
  final DateTime selectedDate;
  final String barberId;

   FetchSlotsSpecificdateRequst({required this.barberId, required this.selectedDate});
}
