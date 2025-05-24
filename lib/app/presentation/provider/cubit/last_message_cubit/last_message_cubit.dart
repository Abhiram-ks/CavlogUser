import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:user_panel/app/data/models/chat_model.dart';

import '../../../../../auth/data/datasources/auth_local_datasource.dart';
import '../../../../data/repositories/fetch_lastmessage_repo.dart';

part 'last_message_state.dart';

class LastMessageCubit extends Cubit<LastMessageState> {
  final FetchLastmessageRepository _repository;
  StreamSubscription<ChatModel?>? _subscription;

  LastMessageCubit(this._repository) : super(LastMessageInitial());

  void lastMessage({required String barberId}) async {
    emit(LastMessageLoading());

    _subscription?.cancel();

    final credentials = await SecureStorageService.getUserCredentials();
    final String? userId = credentials['userId'];
    if (userId == null) {
      emit(LastMessageFailure());
      return;
    }

    _subscription = _repository
        .latestMessage(userId: userId, barberId: barberId)
        .listen((chat) {
      if (chat == null) {
        emit(LastMessageFailure());
      } else {
        emit(LastMessageSuccess(chat));
      }
    }, onError: (_) {
      emit(LastMessageFailure());
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
