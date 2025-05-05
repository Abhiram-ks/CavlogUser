import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';


class StripeConfig {
  static late final String publishableKey;
  static late final String secretKey;

  static void initialize() {
    publishableKey = dotenv.env['STRIPE_PUBLISHABLEKEY']!;
    secretKey = dotenv.env['STRIPE_SECRETKEY']!;
    Stripe.publishableKey = publishableKey;
    Stripe.instance.applySettings();
  }
}
