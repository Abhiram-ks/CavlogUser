import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter/foundation.dart';
import 'package:user_panel/core/keystore/keystore.dart';

class StripeConfig {
  static late final String publishableKey;
  static late final String secretKey;

  static void initialize() {
    publishableKey = EnvConstants.publishableKey;
    secretKey = EnvConstants.secretKey;

    if (!kIsWeb) {
      Stripe.publishableKey = publishableKey;
      Stripe.instance.applySettings();
    } else {
      debugPrint("Stripe initialization skipped on Web.");
    }
  }
}
