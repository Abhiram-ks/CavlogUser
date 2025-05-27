part of 'send_comment_bloc.dart';

abstract class SendCommentEvent {}

class SendCommentButtonPressed extends SendCommentEvent {
  final String comment;
  final String barberId;
  final String docId;

  SendCommentButtonPressed({required this.comment, required this.barberId, required this.docId});
}
