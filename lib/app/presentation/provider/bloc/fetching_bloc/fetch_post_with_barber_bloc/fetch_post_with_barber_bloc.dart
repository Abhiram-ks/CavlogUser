import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:user_panel/app/data/models/post_with_barber_model.dart';

import '../../../../../../auth/data/datasources/auth_local_datasource.dart';
import '../../../../../data/repositories/fetch_post_with_barber_mode.dart';

part 'fetch_post_with_barber_event.dart';
part 'fetch_post_with_barber_state.dart';


class FetchPostWithBarberBloc extends Bloc<FetchPostWithBarberEvent, FetchPostWithBarberState> {
  final PostService _postService;

  FetchPostWithBarberBloc(this._postService) : super(FetchPostWithBarberInitial()) {
    on<FetchPostWithBarberRequest>(_onFetchPostWithBarber);
  }

  Future<void> _onFetchPostWithBarber(
    FetchPostWithBarberRequest event,
    Emitter<FetchPostWithBarberState> emit,
  ) async {
    emit(FetchPostWithBarberLoading());
    final credentials = await SecureStorageService.getUserCredentials();
    final String? userId = credentials['userId'];
    if (userId == null || userId.isEmpty) {
      FetchPostWithBarberFailure('User feching failure');
    }  
    await emit.forEach<List<PostWithBarberModel>>(
      
      _postService.fetchAllPostsWithBarbers(),
      onData: (posts) {
        if (posts.isEmpty) {
          return FetchPostWithBarberEmpty();
        } else {
          return FetchPostWithBarberLoaded(model: posts,userId: userId!);
        }
      },
      onError: (error, _) => FetchPostWithBarberFailure(error.toString()),
    );
  }
}
