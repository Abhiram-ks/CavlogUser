part of 'nearby_barbers_bloc.dart';

abstract class NearbyBarbersEvent {}

class LoadNearbyBarbers extends NearbyBarbersEvent {
  final double lat;
  final double lng;
  final int around;

  LoadNearbyBarbers(this.lat, this.lng, this.around);
}
