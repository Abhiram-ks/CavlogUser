part of 'fetch_chat_barberlebel_bloc.dart';


@immutable
abstract class FetchChatBarberlebelEvent {}
final class FetchChatLebelBarberRequst extends FetchChatBarberlebelEvent{}

final class FetchChatLebelBarberSearch extends FetchChatBarberlebelEvent{
  final String searchController;

  FetchChatLebelBarberSearch(this.searchController);
}