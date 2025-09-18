part of 'delete_account_bloc.dart';

@immutable
abstract class DeleteAccountState {}

final class DeleteAccountInitial extends DeleteAccountState {}

final class DeleteAccountLoadingState extends DeleteAccountState {}
final class DeleteAccountSuccessState extends DeleteAccountState {}
final class DeleteAccountFailureState extends DeleteAccountState {}