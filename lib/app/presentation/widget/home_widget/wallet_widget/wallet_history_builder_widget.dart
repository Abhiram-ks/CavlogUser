import 'package:flutter/material.dart';
import '../../../../../core/themes/colors.dart';

Container historyBuiderWidget(
    {required BuildContext context,
    required double screenWidth,
    required String dateTime,
    required String amount,
    Color? bgColor,
    required String transferId}) {
  return Container(
    decoration: BoxDecoration(
      color: bgColor ?? AppPalette.scafoldClr,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Wallet top-up completed successfully.',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: screenWidth * 0.04,
                ),
              ),
              Text(
                'At: $dateTime',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: screenWidth * 0.035),
              ),
              Text(
                'TransactionId: $transferId',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: screenWidth * 0.035),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '+ $amount',
                style: TextStyle(
                  color: AppPalette.greenClr,
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.04,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Online Transaction',
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
