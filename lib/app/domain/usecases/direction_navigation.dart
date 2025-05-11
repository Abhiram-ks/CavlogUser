import 'package:url_launcher/url_launcher.dart';

class MapHelper {
  static Future<void> openGoogleMaps({
    required double sourceLat,
    required double sourceLng,
    required double destLat,
    required double destLng,
  }) async {
    final googleUrl = Uri.parse('https://www.google.com/maps/dir/?api=1&origin=$sourceLat,$sourceLng&destination=$destLat,$destLng&travelmode=driving');

    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not open Google Maps.');
    }
  }
}
