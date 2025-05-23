
import 'package:flutter/material.dart';
import 'package:user_panel/app/presentation/widget/settings_widget/booking_widget/my_booking_detail_widget/detail_widget.dart';

import '../../../../../data/models/booking_model.dart';
import '../../../search_widget/payment_screen_widgets/payment_filering_widget.dart';

class MyBookingDetailsScreenListsWidget extends StatelessWidget {
  final double screenWidth;
  final BookingModel model;
  final double screenHight;
  const MyBookingDetailsScreenListsWidget({
    super.key,
    required this.screenWidth,
    required this.screenHight,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
     final isOnline = model.paymentMethod.toLowerCase().contains('online banking');
    final double totalServiceAmount = model.serviceType.values.fold(0.0, (sum, value) => sum + value);
    final double platformFee = calculatePlatformFee(totalServiceAmount);
    return MyBookingDetailsPortionWidget(screenWidth: screenWidth, screenHight: screenHight, model: model, isOnline: isOnline, platformFee: platformFee);
  }
}
