import 'dart:math';

import 'package:latlong2/latlong.dart';

List<LatLng> createGeodesicCircle(LatLng center, int radiusInMeters,
    {int points = 60}) {
  const double earthRadius = 6371000.0;
  final double lat = center.latitude * (pi / 180.0);
  final double lng = center.longitude * (pi / 180.0);
  final double d = radiusInMeters / earthRadius;

  return List.generate(points, (i) {
    final double bearing = (2 * pi * i) / points;
    final double latRadians =
        asin(sin(lat) * cos(d) + cos(lat) * sin(d) * cos(bearing));
    final double lngRadians = lng +
        atan2(
          sin(bearing) * sin(d) * cos(lat),
          cos(d) - sin(lat) * sin(latRadians),
        );

    return LatLng(latRadians * (180.0 / pi), lngRadians * (180.0 / pi));
  });
}
