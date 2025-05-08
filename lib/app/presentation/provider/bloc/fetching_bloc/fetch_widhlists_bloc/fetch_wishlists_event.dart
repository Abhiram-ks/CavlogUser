part of 'fetch_wishlists_bloc.dart';


@immutable
abstract class FetchWishlistsEvent  {}
final class FetchWishlistsRequst extends FetchWishlistsEvent {}

final class _EmitWishlistUpdate extends FetchWishlistsEvent {
  final List<BarberModel> barbers;

  _EmitWishlistUpdate(this.barbers);
}
