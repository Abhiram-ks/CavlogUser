part of 'fetch_banners_bloc.dart';

sealed class FetchBannersState {}

final class FetchBannersInitial extends FetchBannersState {}
final class FetchBannersLoading extends FetchBannersState {}
final class FetchBannersEmpty extends FetchBannersState {}
final class FetchBannersLoaded extends FetchBannersState {
  final BannerModels banners;

  FetchBannersLoaded(this.banners);
}
final class FetchBannersFailure extends FetchBannersState {
  final String bannerUrl;

  FetchBannersFailure(this.bannerUrl);
}
