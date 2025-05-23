import 'package:flutter/material.dart';

import '../../../../../core/utils/constant/constant.dart';

double getTotalServiceAmount(List<Map<String, dynamic>> services) {
  return services.fold(
      0.0, (sum, item) => sum + (item['serviceAmount'] as double));
}

double calculatePlatformFee(double totalAmount) {
  return (totalAmount * 0.01);
}

const double exchangeRateINRtoUSD = 0.0118;
double convertINRtoUSD(double amountInINR) {
  return amountInINR * exchangeRateINRtoUSD;
}

Row paymentSummaryTextWidget(
    {required BuildContext context,
    required String prefixText,
    required String suffixText,
    required TextStyle suffixTextStyle,
    required TextStyle prefixTextStyle}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Text(
          prefixText,
          style: suffixTextStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      ConstantWidgets.width40(context),
      Text(
        suffixText,
        style: prefixTextStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  );
}
