part of 'fetch_wishlists_bloc.dart';

abstract class FetchWishlistsState {}

final class FetchWishlistsInitial extends FetchWishlistsState {}
final class FetchWishlistsLoding extends FetchWishlistsState {}
final class FetchWishlistsEmpty extends FetchWishlistsState {}
final class FetchWishlistsLoaded extends FetchWishlistsState {
  final List<BarberModel> barbers;

  FetchWishlistsLoaded(this.barbers);
}

final class FetchWishlistsFailure extends FetchWishlistsState {
  final String error;

  FetchWishlistsFailure(this.error);
}
