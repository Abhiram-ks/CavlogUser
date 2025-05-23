import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:user_panel/core/stripe/stripe_config.dart';

abstract class CreatePaymentIntentUseCase {
  Future<Map<String, dynamic>> stripeCall(
      {required double amount, required String currency});
}

class StripeService implements CreatePaymentIntentUseCase {
  StripeService._();

  static final StripeService instance = StripeService._();

  @override
  Future<Map<String, dynamic>> stripeCall({
    required double amount,
    required String currency,
  }) async {
    try {
      int convertedAmount = (amount * 100).toInt();

      final Dio dio = Dio();
      final response = await dio.post('https://api.stripe.com/v1/payment_intents',
        data: {
          'amount': convertedAmount.toString(),
          'currency': currency,
          'payment_method_types[]': 'card',
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${StripeConfig.secretKey}',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );


        log('Stripe PaymentIntent created: ${response.data}');
        return response.data;
    } catch (e) {
      log('response stripe: $e');
      throw Exception('Failed to create PaymentIntent: $e');
    }
  }
}
