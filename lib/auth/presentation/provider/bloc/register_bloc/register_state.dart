part of 'register_bloc.dart';

abstract class RegisterState {}
final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}
final class RegisterSuccess extends RegisterState {}
final class RegisterFailure extends RegisterState {
  final String error;
  RegisterFailure(this.error);
}

final class SubmitionConfirmationAlertState extends RegisterState{}