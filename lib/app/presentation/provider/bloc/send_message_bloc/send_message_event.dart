part of 'send_message_bloc.dart';

@immutable
abstract class SendMessageEvent {}
final class SendTextMessage extends SendMessageEvent {
  final String message;
  final String userId;
  final String barberId;

  SendTextMessage({
    required this.message,
    required this.userId,
    required this.barberId,
  });
}

final class SendImageMessage extends SendMessageEvent {
  final String image;
  final String userId;
  final String barberId;

  SendImageMessage({
    required this.image,
    required this.userId,
    required this.barberId,
  });
}