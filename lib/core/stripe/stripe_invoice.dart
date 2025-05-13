import 'package:url_launcher/url_launcher.dart';

Future<void> launchStripePaymentPage(String paymentIntentId) async {
  final url = 'https://dashboard.stripe.com/test/payments/$paymentIntentId';

  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}
 