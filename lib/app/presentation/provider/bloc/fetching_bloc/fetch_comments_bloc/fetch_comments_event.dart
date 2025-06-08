part of 'fetch_comments_bloc.dart';


@immutable
abstract class FetchCommentsEvent {}

final class FetchCommentRequst extends FetchCommentsEvent {
  final String barberId;
  final String docId;

  FetchCommentRequst({required this.barberId, required this.docId});
}