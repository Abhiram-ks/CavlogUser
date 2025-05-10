import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

class GeocodingHelper {
  static Future<LatLng> addressToLatLng(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        return LatLng(loc.latitude, loc.longitude);
      } else {
        throw Exception('No coordinates found for the address');
      }
    } catch (e) {
      throw Exception('Failed to convert address: $e');
    }
  }
}
