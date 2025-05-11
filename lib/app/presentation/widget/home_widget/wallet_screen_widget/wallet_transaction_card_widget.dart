
import 'package:flutter/material.dart';

import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constant/constant.dart';

class TrasactionCardsWalletWidget extends StatelessWidget {
  final double screenHeight;
  final String amount;
  final Color amountColor;
  final String status;
  final IconData statusIcon;
  final Color stusColor;
  final String id;
  final String dateTime;
  final String method;
  final Color? mainColor;
  final String description;
  final VoidCallback ontap;

  const TrasactionCardsWalletWidget({
    super.key,
    required this.screenHeight,
    required this.amount,
    required this.amountColor,
    required this.status,
    required this.statusIcon,
    required this.id,
    required this.stusColor,
    required this.dateTime,
    this.mainColor,
    required this.method,
    required this.description,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: screenHeight * 0.14,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: mainColor ?? AppPalette.scafoldClr,
          border: Border.all(color: Colors.grey.shade300),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    method,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                      ),
                      ConstantWidgets.width20(context),
                      Expanded(
                        child: Text(
                          dateTime,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    id,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      amount,
                      style: TextStyle(
                        color: amountColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ConstantWidgets.hight10(context),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: stusColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: stusColor),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(statusIcon, color: stusColor, size: 16),
                          ConstantWidgets.hight10(context),
                          Text(status, style: TextStyle(color: stusColor)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
