

  import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constant/constant.dart';
import '../../../screens/pages/search/payment_screen/payment_screen.dart';
import '../../search_widget/payment_screen_widgets/payment_filering_widget.dart';

Column digitalPaymentSummaryWidget(
      BuildContext context,
      Color balanceColor,
      double balance,
      double bookingAmount,
      double isShortfallAmount,
      double remainingBalance) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Digital Payment Summary",
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ],
        ),
        ConstantWidgets.hight20(context),
        paymentSummaryTextWidget(
          context: context,
          prefixText: 'Wallet Balance',
          prefixTextStyle: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w500, color: balanceColor),
          suffixText: '₹ ${balance.toStringAsFixed(2)}',
          suffixTextStyle: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w500, color: AppPalette.blackClr),
        ),
        paymentSummaryTextWidget(
          context: context,
          prefixText: 'Booking Amount',
          prefixTextStyle: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w500, color: AppPalette.blueClr),
          suffixText: '₹ ${bookingAmount.toStringAsFixed(2)}',
          suffixTextStyle: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w500, color: AppPalette.blueClr),
        ),
        paymentSummaryTextWidget(
          context: context,
          prefixText: 'Shortfall Amount',
          prefixTextStyle: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w500, color: AppPalette.blackClr),
          suffixText: '₹ ${isShortfallAmount.toStringAsFixed(2)}',
          suffixTextStyle: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w500, color: AppPalette.blackClr),
        ),
        paymentSummaryTextWidget(
          context: context,
          prefixText: 'Remaining Balance',
          prefixTextStyle: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w500, color: AppPalette.blackClr),
          suffixText: '₹ ${remainingBalance.toStringAsFixed(2)}',
          suffixTextStyle: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w500, color: AppPalette.blackClr),
        ),
        ConstantWidgets.hight20(context),
        Divider(color: AppPalette.hintClr),
        paymentSummaryTextWidget(
          context: context,
          prefixText: 'Remaining Balance',
          prefixTextStyle: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w500, color: AppPalette.greenClr),
          suffixText: '₹ ${bookingAmount.toStringAsFixed(2)}',
          suffixTextStyle: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w500, color: AppPalette.blackClr),
        ),
      ],
    );
  }

  
