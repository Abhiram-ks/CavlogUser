// bottom_sheet_payment_option.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_panel/core/common/custom_lottie_widget.dart';
import 'package:user_panel/core/utils/image/app_images.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constant/constant.dart';


class BottomSheetPaymentOption {
  void showBottomSheet({
    required BuildContext context,
    required VoidCallback walletPaymentAction,
    required VoidCallback stripePaymentAction,
    required double screenWidth,
    required double screenHeight,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppPalette.whiteClr,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final double itemWidth  = (screenWidth * 0.9) / 2;
        final double itemHeight = itemWidth; 

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstantWidgets.hight10(context),
              Text(
                "Choose Your Payment Method",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              ConstantWidgets.hight10(context),
              Text(
                'After choosing, follow the on‑screen steps to complete your booking.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              ConstantWidgets.hight30(context),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: walletPaymentAction,
                    child: Container(
                      width: itemWidth,
                      height: itemHeight,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppPalette.whiteClr,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LottieFilesCommon.load(
                            assetPath: LottieImages.walletLottie,
                            width: itemWidth * 0.6,
                            height: itemWidth * 0.6,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Pay with Wallet',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: stripePaymentAction,
                    
                    child: Container(
                      width: itemWidth,
                      height: itemHeight,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppPalette.whiteClr,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LottieFilesCommon.load(
                            assetPath: LottieImages.cardLottie,
                            width: itemWidth * 0.6,
                            height: itemWidth * 0.6,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Online payment',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
