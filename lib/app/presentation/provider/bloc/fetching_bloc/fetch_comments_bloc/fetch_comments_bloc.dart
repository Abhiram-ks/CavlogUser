
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:user_panel/app/data/models/comment_model.dart';
import 'package:user_panel/app/data/repositories/fetch_comment_repo.dart';

import '../../../../../../auth/data/datasources/auth_local_datasource.dart';

part 'fetch_comments_event.dart';
part 'fetch_comments_state.dart';

class FetchCommentsBloc extends Bloc<FetchCommentsEvent, FetchCommentsState> {
  final SendCommentRepository _repository;
  FetchCommentsBloc(this._repository) : super(FetchCommentsInitial()) {
    on<FetchCommentRequst>(_onFetchCommentsRequst);
  }

  Future<void> _onFetchCommentsRequst(
    FetchCommentRequst event,
    Emitter<FetchCommentsState> emit,
  ) async {
    emit(FetchCommentsLoading());

    try {
       final credentials =await SecureStorageService.getUserCredentials();
       final String? userId = credentials['userId'];
        if (userId == null || userId.isEmpty) {
         emit(FetchCommentsFailure());
          return;
        }
      await emit.forEach(
        _repository.fetchComments(barberId: event.barberId, docId: event.docId), 
        onData: (comments) {
          if (comments.isEmpty) {
            return FetchCommentsEmpty();
          } else {
            return FetchCommentsSuccess(comments: comments, userId: userId);
          }
        },
        onError:  (_, __) => FetchCommentsFailure()
      );
    } catch (e) {
      emit(FetchCommentsFailure());
    }
  }

}
