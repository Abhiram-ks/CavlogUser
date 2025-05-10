
import 'package:user_panel/app/domain/entitiles/barbersho_entity.dart';
import 'package:user_panel/app/domain/repositories/barbershop_services_repo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/barbershop_model.dart';


class BarberShopRepositoryImpl implements BarbershopServicesRepository {
  @override
  Future<List<BarberShopData>> fetchNearbyBarberShops(double lat, double lng, int around) async {
    final query = '''
      [out:json];
      (
        node["shop"="hairdresser"](around:$around,$lat,$lng);
        way["shop"="hairdresser"](around:$around,$lat,$lng);
      );
      out body;
      >;
      out skel qt;
    ''';

    final url = Uri.parse('https://overpass-api.de/api/interpreter?data=${Uri.encodeComponent(query)}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List elements = jsonData['elements'];

      return elements
          .where((e) => e['lat'] != null && e['lon'] != null)
          .map<BarberShopData>((e) => BarberShopModel.fromOverpassJson(e, lat, lng))
          .toList()
        ..sort((a, b) => a.distance.compareTo(b.distance));
    } else {
      throw Exception('Failed to fetch nearby barber shops');
    }
  }
}
