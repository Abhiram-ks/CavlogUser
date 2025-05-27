import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:user_panel/app/data/datasources/send_comment_remote_datasource.dart';

import '../../../../../auth/data/datasources/auth_local_datasource.dart';

part 'send_comment_event.dart';
part 'send_comment_state.dart';

class SendCommentBloc extends Bloc<SendCommentEvent, SendCommentState> {
  final SendCommentRemoteDatasource _repo;
  SendCommentBloc(this._repo) : super(SendCommentInitial()) {
    on<SendCommentButtonPressed>(_sendComment);

  }

  Future<void> _sendComment(
    SendCommentButtonPressed event, Emitter<SendCommentState> emit) async {
    emit(SendCommentLoading());
    try {
         final credentials = await SecureStorageService.getUserCredentials();
      final String? userId = credentials['userId'];

      if (userId == null || userId.isEmpty) {
        emit(SendCommentFailure('Failed to send comment: User ID is null or empty'));
        return;
      }
      final success = await _repo.sendComment(
        userId:  userId,
        comment: event.comment,
        docId: event.docId,
        barberId: event.barberId,
      );
      if (success) {
        log('success sate');
        emit(SendCommentSuccess());
      } else {
        emit(SendCommentFailure("Failed to send comment"));
      }
    } catch (error) {
      emit(SendCommentFailure("Failed to send comment: $error"));
    }
  }
}
