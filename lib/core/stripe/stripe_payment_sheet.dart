import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:user_panel/core/stripe/stripe_services_impl.dart';


class StripePaymentSheetHandler {
  StripePaymentSheetHandler._();

  static final StripePaymentSheetHandler instance = StripePaymentSheetHandler._();

  Future<String?> presentPaymentSheet({
    required BuildContext context,
    required double amount,
    required String label,
    required String currency,
  }) async {
    final CreatePaymentIntentUseCase paymentIntentUseCase = StripeService.instance;
    final Stripe stripe = Stripe.instance;

    try {
      final intentPaymentData = await paymentIntentUseCase.stripeCall(
        amount: amount,
        currency: currency,
      );

      final String clientSecret = intentPaymentData['client_secret'];
      final String paymentId = intentPaymentData['id'];


      await stripe.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: 'Cavlog official',
          paymentIntentClientSecret: clientSecret,
          style: ThemeMode.light,
          
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'IN',
            testEnv: true,
          ),
          customFlow: false,
          primaryButtonLabel: label
        ),
      );

      await stripe.presentPaymentSheet();
      log('paymet id is like $paymentId');
      return paymentId;
    } catch (e) {
      log('Payment Error: $e');
      return null;
    }
  }
}
