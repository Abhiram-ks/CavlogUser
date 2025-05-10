import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:user_panel/app/data/models/banner_models.dart';
import 'package:user_panel/app/data/repositories/fetch_banner_repo.dart';
part 'fetch_banners_event.dart';
part 'fetch_banners_state.dart';


class FetchBannersBloc extends Bloc<FetchBannersEvent, FetchBannersState> {
  final FetchBannerRepository _repository;

  FetchBannersBloc(this._repository) : super(FetchBannersInitial()) {
    on<FetchBannersRequest>(_onFetchBannersRequest);
  }

  Future<void> _onFetchBannersRequest(
    FetchBannersRequest event,
    Emitter<FetchBannersState> emit,
  ) async {
    emit(FetchBannersLoading());

    try {
      await emit.forEach<BannerModels>(
        _repository.streamBanners(),
        onData: (banner) {
          if (banner.imageUrls.isEmpty) {
            return FetchBannersEmpty();
          } else {
            return FetchBannersLoaded(banner);
          }
        },
        onError: (error, stackTrace) {
          return FetchBannersFailure('Failed to fetch banners: $error');
        },
      );
    } catch (e) {
      emit(FetchBannersFailure('Unexpected error: $e'));
    }
  }
}

