import 'package:bloc/bloc.dart';

import '../../../../data/repositories/request_for_chatupdate_repo.dart';

class StatusChatRequstDartCubit extends Cubit<StatusChatRequstState> {
  final RequestForChatupdateRepository repository;
  StatusChatRequstDartCubit(this.repository) : super(StatusChatRequstInitial());

  Future<void> updateChatStatus({
    required String userId,
    required String barberId
  }) async {
    await repository.chatStatusChange(userId: userId, barberId: barberId);
  }
}


abstract class StatusChatRequstState {}
final class StatusChatRequstInitial extends StatusChatRequstState {}