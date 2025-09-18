part of 'register_bloc.dart';

abstract class RegisterEvent{}
final class RegisterPersonalData extends RegisterEvent{
  final String fullName;
  final String phoneNumber;
  final String address;

  RegisterPersonalData({required this.fullName, required this.phoneNumber, required this.address});
}

final class RegisterCredentialsData extends RegisterEvent {
  final String email;
  final String password;

  RegisterCredentialsData({required this.email, required this.password});
}
class RegisterSubmit extends RegisterEvent {}