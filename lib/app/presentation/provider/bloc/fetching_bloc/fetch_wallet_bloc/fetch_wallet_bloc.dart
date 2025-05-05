import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import '../../../../../../auth/data/datasources/auth_local_datasource.dart';
import '../../../../../data/models/wallet_model.dart';
import '../../../../../data/repositories/fetch_wallets_repo.dart';

part 'fetch_wallet_event.dart';
part 'fetch_wallet_state.dart';

class FetchWalletBloc extends Bloc<FetchWalletEvent, FetchWalletState> {
  final FetchWalletsRepository _walletRepository;
  StreamSubscription<WalletModel?>? _walletSubscription;

  FetchWalletBloc(this._walletRepository) : super(FetchWalletInitial()) {
    on<FetchWalletRequest>(_onFetchWalletRequest);
    on<FetchWalletUpdated>(_onFetchWalletUpdated);
  }

  Future<void> _onFetchWalletRequest(
    FetchWalletRequest event,
    Emitter<FetchWalletState> emit,
  ) async {
    emit(FetchWalletLoading());

    try {
      final credentials = await SecureStorageService.getUserCredentials();
      final String? userId = credentials['userId'];

      if (userId == null) {
        emit(FetchWalletFailure('User not found. Request failed.'));
        return;
      }


      await _walletSubscription?.cancel();

      _walletSubscription = _walletRepository
          .streamWalletFetch(userId: userId)
          .listen((wallet) {
        add(FetchWalletUpdated(wallet));
      }, onError: (e) {
        add(FetchWalletUpdated(null)); 
      });
    } catch (e) {
      emit(FetchWalletFailure("Exception: ${e.toString()}"));
    }
  }

  void _onFetchWalletUpdated(
    FetchWalletUpdated event,
    Emitter<FetchWalletState> emit,
  ) {
    if (event.wallet == null) {
      emit(FetchWalletEmpty());
    } else {
      emit(FetchWalletLoaded(event.wallet!));
    }
  }

  @override
  Future<void> close() {
    _walletSubscription?.cancel();
    return super.close();
  }
}
