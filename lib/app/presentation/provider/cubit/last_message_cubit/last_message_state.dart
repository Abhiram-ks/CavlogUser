part of 'last_message_cubit.dart';


@immutable
abstract class LastMessageState {}

final class LastMessageInitial extends LastMessageState {}
final class LastMessageLoading extends LastMessageState {}
final class LastMessageSuccess extends LastMessageState {
  final ChatModel message;
  LastMessageSuccess(this.message);
}
final class LastMessageFailure extends LastMessageState {}
