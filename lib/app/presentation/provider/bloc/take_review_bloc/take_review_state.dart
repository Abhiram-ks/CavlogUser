part of 'take_review_bloc.dart';


@immutable
abstract class TakeReviewState {}

final class TakeReviewInitial extends TakeReviewState {}
final class TakeReviewSuccess extends TakeReviewState {
  final String userId;
  final String barberId;

  TakeReviewSuccess({required this.barberId, required this.userId});
}
final class TakeReviewFailure extends TakeReviewState {}
