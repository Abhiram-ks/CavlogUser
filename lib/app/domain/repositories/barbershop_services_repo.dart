import 'package:user_panel/app/domain/entitiles/barbersho_entity.dart';

abstract class BarbershopServicesRepository {
  Future<List<BarberShopData>> fetchNearbyBarberShops(double lat, double lng, int around);
}

class GetNearbyBarberShops {
  final BarbershopServicesRepository repository;
  GetNearbyBarberShops(this.repository);

  Future<List<BarberShopData>> call(double lat, double lng, int around) {
    return repository.fetchNearbyBarberShops(lat, lng, around);
  }
}