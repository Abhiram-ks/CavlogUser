part of 'fetch_wishlist_singlebarber_cubit.dart';

abstract class FetchWishlistSinglebarberState {}

final class FetchWishlistSinglebarberInitial extends FetchWishlistSinglebarberState {}

class FetchWishlistSinglebarberLoaded  extends  FetchWishlistSinglebarberState{
  final bool isLiked;

  FetchWishlistSinglebarberLoaded(this.isLiked);
}