import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter/foundation.dart';

class StripeConfig {
  static late final String publishableKey;
  static late final String secretKey;

  static void initialize() {
    publishableKey = dotenv.env['STRIPE_PUBLISHABLEKEY']!;
    secretKey = dotenv.env['STRIPE_SECRETKEY']!;

    if (!kIsWeb) {
      Stripe.publishableKey = publishableKey;
      Stripe.instance.applySettings();
    } else {
      debugPrint("Stripe initialization skipped on Web.");
    }
  }
}
