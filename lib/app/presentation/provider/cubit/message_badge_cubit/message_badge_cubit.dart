import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:user_panel/app/data/repositories/fetch_lastmessage_repo.dart';

import '../../../../../auth/data/datasources/auth_local_datasource.dart';

part 'message_badge_state.dart';

class MessageBadgeCubit extends Cubit<MessageBadgeState> {
  final FetchLastmessageRepository _repository;
  StreamSubscription<int>? _subscription;

  MessageBadgeCubit(this._repository) : super(MessageBadgeInitial());

   numberOfBadges({
    required String barberId,
  }) async{
    emit(MessageBadgeLoading());

    _subscription?.cancel(); 
     final credentials = await SecureStorageService.getUserCredentials();
      final String? userId = credentials['userId'];
    if (userId == null) {
      return MessageBadgeFailure();
    }

    _subscription = _repository .messageBadges(userId: userId, barberId: barberId)
        .listen((count) {
      if (count == 0) {
        emit(MessageBadgeEmpty());
      } else {
        emit(MessageBadgeSuccess(count));
      }
    }, onError: (_) {
      emit(MessageBadgeFailure());
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
