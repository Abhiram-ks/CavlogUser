import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart'; 

Future<void> requestNotificationPermission() async {
  if (kIsWeb) {
    return;
  }

  final status = await Permission.notification.status;

  if (status.isDenied || status.isRestricted) {
    final result = await Permission.notification.request();

    if (result.isPermanentlyDenied) {
      await openAppSettings();
    }
  }
}