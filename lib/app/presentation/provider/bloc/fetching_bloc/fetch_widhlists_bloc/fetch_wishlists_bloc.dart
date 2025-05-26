import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:user_panel/app/data/models/barber_model.dart';
import '../../../../../../auth/data/datasources/auth_local_datasource.dart';
import '../../../../../data/repositories/fetch_wishlist_repo.dart';
part 'fetch_wishlists_event.dart';
part 'fetch_wishlists_state.dart';

class FetchWishlistsBloc extends Bloc<FetchWishlistsEvent, FetchWishlistsState> {
  final FetchWishlistRepository wishlistRepository;
  StreamSubscription<List<BarberModel>>? _wishlistSubscription;

  FetchWishlistsBloc(this.wishlistRepository) : super(FetchWishlistsInitial()) {
    on<FetchWishlistsRequst>(_onFetchWishlistRequested);
  }

  Future<void> _onFetchWishlistRequested(
    FetchWishlistsRequst event,
    Emitter<FetchWishlistsState> emit,
  ) async {
    emit(FetchWishlistsLoding());
    try {
      final credentials = await SecureStorageService.getUserCredentials();
      final String? userId = credentials['userId'];

      if (userId == null || userId.isEmpty) {
        emit(FetchWishlistsFailure('User not logged in'));
        return;
      }

      await emit.forEach(
        wishlistRepository.streamWishList(userId: userId),
         onData: (barber) {
          if (barber.isEmpty) {
            return FetchWishlistsEmpty();
          } else {
            return FetchWishlistsLoaded(barber);
          }
         },
 onError: (error, stackTrace) {
  return FetchWishlistsFailure('Error: ${error.toString()}');
 } 
        );
    } catch (e) {
      emit(FetchWishlistsFailure('Error: ${e.toString()}'));
    }
  }



  @override
  Future<void> close() {
    _wishlistSubscription?.cancel();
    return super.close();
  }
}
