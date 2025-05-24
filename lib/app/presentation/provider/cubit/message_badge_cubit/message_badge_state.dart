part of 'message_badge_cubit.dart';


@immutable
abstract class MessageBadgeState {}

final class MessageBadgeInitial extends MessageBadgeState {}
final class MessageBadgeLoading extends MessageBadgeState {}
final class MessageBadgeEmpty extends MessageBadgeState {}
final class MessageBadgeSuccess extends MessageBadgeState {
  final int badges;
  
  MessageBadgeSuccess(this.badges);
}
final class MessageBadgeFailure extends MessageBadgeState {}
