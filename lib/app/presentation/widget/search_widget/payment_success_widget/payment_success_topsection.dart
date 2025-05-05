
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:user_panel/app/presentation/screens/pages/search/payment_screen/payment_screen.dart';
import 'package:user_panel/core/common/custom_lottie_widget.dart';
import 'package:user_panel/core/utils/constant/constant.dart';
import 'package:user_panel/core/utils/image/app_images.dart';
import '../../../../../core/themes/colors.dart';

class PaymentSuccessTopsection extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final String barberUid;
  final bool isWallet;
  final String label;
  final List<Map<String, dynamic>> selectedServices;

  const PaymentSuccessTopsection({
    super.key, required this.screenHeight, required this.screenWidth, required this.barberUid, required this.selectedServices, required this.label, required this.isWallet,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final formattedTime = DateFormat('hh:mm a').format(DateTime.now());
    final double totalAmount = getTotalServiceAmount(selectedServices);
    final double platformFee = calculatePlatformFee(totalAmount);

    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            child: ClipPath(
                  clipper: ReceiptClipper(),
              child: Container(
                color: const Color.fromARGB(255, 222, 224, 226),
                width: screenWidth,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * .04, vertical: screenHeight * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: LottieFilesCommon.load(assetPath: LottieImages.varifySuccess, width: screenWidth * 0.3, height: screenWidth * 0.3),
                      ), ConstantWidgets.hight10(context),
                      Text( "Payment Success!",style: TextStyle( color: AppPalette.greenClr,fontWeight: FontWeight.bold,fontSize: 20)),
                      ConstantWidgets.hight10(context),
                      Text( "Your payment has been successfully done.",style: TextStyle(color: AppPalette.blackClr)),
                      ConstantWidgets.hight30(context),
                       const Divider(color: AppPalette.greyClr),
                      ConstantWidgets.hight20(context),
                      Text( "Total Payment", style: TextStyle(color: AppPalette.blackClr)),
                      Text(
                        label,
                        style: TextStyle(
                          color: AppPalette.blackClr,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      ConstantWidgets.hight30(context),
                      paymentSummaryTextWidget(
                        context: context,
                        prefixText: 'Payment Date',
                        suffixText: formattedDate,
                        suffixTextStyle: TextStyle(color: AppPalette.greyClr),
                        prefixTextStyle: TextStyle(
                          color: AppPalette.greyClr,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      paymentSummaryTextWidget(
                        context: context,
                        prefixText: 'Payment Time',
                        suffixText: formattedTime,
                        suffixTextStyle: TextStyle(color: AppPalette.greyClr),
                        prefixTextStyle: TextStyle(
                          color: AppPalette.greyClr,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      paymentSummaryTextWidget(
                        context: context,
                        prefixText: 'Payment Method',
                        suffixText: isWallet ? 'Wallet Transfer' : 'Card/Bank Transfer',
                        suffixTextStyle: TextStyle(color: AppPalette.greyClr),
                        prefixTextStyle: TextStyle(color: AppPalette.blackClr),
                      ),
                      const Divider(color: AppPalette.greyClr),
                      ConstantWidgets.hight20(context),
                      Text("Payment summary", style: TextStyle(color: AppPalette.greyClr),
                      ),ConstantWidgets.hight10(context),
                      Column(children: [
                ...selectedServices.map((service) {
                  final String serviceName = service['serviceName'];
                  final double serviceAmount = service['serviceAmount'];
              
                  return paymentSummaryTextWidget(
                    context: context,
                    prefixText: serviceName,
                    suffixText: '₹ ${serviceAmount.toStringAsFixed(0)}',
                    prefixTextStyle:
                        GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w400),
                    suffixTextStyle:
                        GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w400),
                  );
                }),
                paymentSummaryTextWidget(
                  context: context,
                  prefixText: 'Platform fee(1%)',
                  prefixTextStyle: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w500, color: AppPalette.blackClr),
                  suffixText: '₹ $platformFee',
                  suffixTextStyle: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w500, color: AppPalette.blueClr),
                ),
                ConstantWidgets.hight20(context),
                Divider(
                  color: AppPalette.greyClr,
                ),
                paymentSummaryTextWidget(
                  context: context,
                  prefixText: 'Total price',
                  prefixTextStyle: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold, color: AppPalette.greenClr),
                  suffixText: '₹ ${totalAmount+ platformFee}',
                  suffixTextStyle: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold, color: AppPalette.blackClr),
                ),
                ConstantWidgets.hight20(context)
              ]),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class ReceiptClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double radius = 20.0;
    const double cutRadius = 15.0;
    const int cuts = 10; 
    final double cutWidth = size.width / (cuts * 2);

    Path path = Path();

    path.moveTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);
    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius);
    path.lineTo(size.width, size.height - cutRadius);
    for (int i = 0; i < cuts * 2; i++) {
      double x = size.width - (i * cutWidth);
      if (i.isEven) {
        path.arcToPoint(
          Offset(x - cutWidth, size.height - cutRadius),
          radius: Radius.circular(cutRadius),
          clockwise: false,
        );
      } else {
        path.arcToPoint(
          Offset(x - cutWidth, size.height - cutRadius),
          radius: Radius.circular(cutRadius),
          clockwise: true,
        );
      }
    }
    path.lineTo(0, size.height - cutRadius);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}