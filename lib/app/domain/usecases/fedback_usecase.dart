import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> sendFeedback() async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'cavlogenoia@gmail.com',
    query: 'subject=Feedback for smartBarber Booking App&body=Hi Team Cavlog,%0A%0AI would like to share the following feedback:%0A%0A',
  );
  try {
    await launchUrl(emailLaunchUri);
  } catch (e) {
    debugPrint("Error sending feedback: $e");
  }
}
