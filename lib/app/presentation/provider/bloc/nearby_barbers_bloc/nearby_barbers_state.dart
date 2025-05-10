part of 'nearby_barbers_bloc.dart';


@immutable
abstract class NearbyBarbersState {}

class NearbyBarbersInitial extends NearbyBarbersState {}

class NearbyBarbersLoading extends NearbyBarbersState {}

class NearbyBarbersLoaded extends NearbyBarbersState {
  final List<BarberShopData> barbers;
  final int around;

  NearbyBarbersLoaded(this.barbers,this.around);
}

class NearbyBarbersError extends NearbyBarbersState {
  final String message;

  NearbyBarbersError(this.message);
}
