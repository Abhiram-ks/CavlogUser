import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:user_panel/app/data/datasources/firebase_review_datasource.dart';
import '../../../../../auth/data/datasources/auth_local_datasource.dart';
part 'take_review_event.dart';
part 'take_review_state.dart';

class TakeReviewBloc extends Bloc<TakeReviewEvent, TakeReviewState> {
  final ReviewRemoteDatasources _repo;
  TakeReviewBloc(this._repo) : super(TakeReviewInitial()) {
    on<TakeReviewFunction>(_takeReview);
  }


  Future<void> _takeReview(
    TakeReviewFunction event,
    Emitter<TakeReviewState> emit,
  ) async {
    try {
      final credentials = await SecureStorageService.getUserCredentials();
      final String? userId = credentials['userId'];

      if (userId == null || userId.isEmpty) {
        emit(TakeReviewFailure());
        return;
      }
      final String? response = await _repo.takeReview(userId: userId);
      if (response == null) {
        emit(TakeReviewFailure());
        return;
      }
      emit(TakeReviewSuccess(barberId: response, userId: userId));

    } catch (e) {
      emit(TakeReviewFailure());
    }
    
  }
}
