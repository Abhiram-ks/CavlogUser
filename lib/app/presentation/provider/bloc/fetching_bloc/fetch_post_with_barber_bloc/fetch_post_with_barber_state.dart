part of 'fetch_post_with_barber_bloc.dart';



@immutable
abstract class FetchPostWithBarberState {}
final class FetchPostWithBarberInitial extends FetchPostWithBarberState {}
final class FetchPostWithBarberLoading extends FetchPostWithBarberState {}
final class FetchPostWithBarberEmpty extends FetchPostWithBarberState {}
final class FetchPostWithBarberLoaded extends FetchPostWithBarberState {
  final List<PostWithBarberModel> model;
  final String userId;

  FetchPostWithBarberLoaded({required this.model,required this.userId});
}

final class FetchPostWithBarberFailure extends FetchPostWithBarberState {
  final String errorMessage;

  FetchPostWithBarberFailure( this.errorMessage);
}
