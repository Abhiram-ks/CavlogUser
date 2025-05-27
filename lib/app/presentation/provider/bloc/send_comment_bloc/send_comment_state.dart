part of 'send_comment_bloc.dart';

abstract class SendCommentState {}

final class SendCommentInitial extends SendCommentState {}
final class SendCommentLoading extends SendCommentState {}
final class SendCommentSuccess extends SendCommentState {}
final class SendCommentFailure extends SendCommentState {
  final String error;

  SendCommentFailure(this.error);
}