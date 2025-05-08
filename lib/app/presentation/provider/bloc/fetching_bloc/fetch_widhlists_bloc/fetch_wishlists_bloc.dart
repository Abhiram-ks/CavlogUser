import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:user_panel/app/data/models/barber_model.dart';
import '../../../../../../auth/data/datasources/auth_local_datasource.dart';
import '../../../../../data/repositories/fetch_wishlist_repo.dart';
part 'fetch_wishlists_event.dart';
part 'fetch_wishlists_state.dart';
class FetchWishlistsBloc
    extends Bloc<FetchWishlistsEvent, FetchWishlistsState> {
  final FetchWishlistRepository wishlistRepository;
  StreamSubscription<List<BarberModel>>? _wishlistSubscription;

  FetchWishlistsBloc(this.wishlistRepository)
      : super(FetchWishlistsInitial()) {
    on<FetchWishlistsRequst>(_onFetchWishlistRequested);
    on<_EmitWishlistUpdate>((event, emit) {
  if (event.barbers.isEmpty) {
    emit(FetchWishlistsEmpty());
  } else {
    emit(FetchWishlistsLoaded(event.barbers));
  }
});

  }

  Future<void> _onFetchWishlistRequested(
    FetchWishlistsRequst event,
    Emitter<FetchWishlistsState> emit,
  ) async {
    emit(FetchWishlistsLoding());
    try {
      final credentials = await SecureStorageService.getUserCredentials();
      final String? userId = credentials['userId'];

      if (userId == null) {
        emit(FetchWishlistsFailure('User not logged in'));
        return;
      }

      await _wishlistSubscription?.cancel();

      _wishlistSubscription = wishlistRepository
          .streamWishList(userId: userId)
          .listen((barberList) {
        add(_EmitWishlistUpdate(barberList));
      });
    } catch (e) {
      emit(FetchWishlistsFailure(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _wishlistSubscription?.cancel();
    return super.close();
  }
}
