part of 'delete_account_bloc.dart';

abstract class DeleteAccountEvent {}

final class DeleteAccountProceed extends DeleteAccountEvent{
  final String password;

  DeleteAccountProceed(this.password);
}
