
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constant/constant.dart';
import '../../../../data/models/slot_model.dart' show SlotModel;
import '../../../../domain/usecases/data_listing_usecase.dart' show formatTimeRange;
import '../../../screens/pages/search/payment_screen/payment_screen.dart';
import '../booking_screen_widget/booking_chips_maker.dart';
import 'payment_filering_widget.dart';

class PaymentBottomSectionWidget extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final List<SlotModel> selectedSlots;
  final List<Map<String, dynamic>> selectedServices;
  const PaymentBottomSectionWidget(
      {super.key,
      required this.screenHeight,
      required this.screenWidth,
      required this.selectedSlots,
      required this.selectedServices});

  @override
  State<PaymentBottomSectionWidget> createState() =>
      _PaymentBottomSectionWidgetState();
}

class _PaymentBottomSectionWidgetState
    extends State<PaymentBottomSectionWidget> {
  @override
  Widget build(BuildContext context) {
    final double totalAmount = getTotalServiceAmount(widget.selectedServices);
    final double platformFee = calculatePlatformFee(totalAmount);
    return Container(
      width: widget.screenWidth,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: AppPalette.whiteClr),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: widget.screenWidth * .04,
            vertical: widget.screenHeight * .03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstantWidgets.width20(context),
                Text('Date & time',  style: GoogleFonts.plusJakartaSans( fontWeight: FontWeight.bold),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            ConstantWidgets.hight10(context),
            Text(
              'You have selected "${widget.selectedSlots.length}" slot(s). Please review and confirm your selected time slots below:',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: 5.0,
                runSpacing: 5.0,
                children: widget.selectedSlots.map((slot) {
                  final formattedDate = slot.date;
                  String formattedStartTime = formatTimeRange(slot.startTime);

                  return ClipChipMaker.build(
                      text: '$formattedDate - $formattedStartTime',
                      actionColor: const Color.fromARGB(255, 239, 241, 246),
                      textColor: AppPalette.blackClr,
                      backgroundColor: AppPalette.whiteClr,
                      borderColor: AppPalette.hintClr,
                      onTap: () {});
                }).toList(),
              ),
            ),
            ConstantWidgets.hight10(context),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstantWidgets.width20(context),
                Text('Chosen service(s)',
                    style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            ConstantWidgets.hight10(context),
            Text(
              'Selected "${widget.selectedServices.length}" service(s). Review below:',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: 5.0,
                runSpacing: 5.0,
                children: widget.selectedServices.map((service) {
                  final String serviceName = service['serviceName'];
                  final double serviceAmount = service['serviceAmount'];

                  return ClipChipMaker.build(
                    text:
                        '$serviceName  - ₹${serviceAmount.toStringAsFixed(0)}',
                    actionColor: const Color.fromARGB(255, 239, 241, 246),
                    textColor: AppPalette.blackClr,
                    backgroundColor: AppPalette.whiteClr,
                    borderColor: AppPalette.hintClr,
                    onTap: () {},
                  );
                }).toList(),
              ),
            ),
            ConstantWidgets.hight30(context),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Payment summary',
                    style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            ConstantWidgets.hight20(context),
            Column(
              children: [
              ...widget.selectedServices.map((service) {
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
                suffixText: '₹ ${platformFee.toStringAsFixed(2)}',
                suffixTextStyle: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w500, color: AppPalette.blueClr),
              ),
              ConstantWidgets.hight20(context),
              Divider(
                color: AppPalette.hintClr,
              ),
              paymentSummaryTextWidget(
                context: context,
                prefixText: 'Total price',
                prefixTextStyle: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold, color: AppPalette.greenClr),
                suffixText: '₹ ${totalAmount + platformFee}',
                suffixTextStyle: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold, color: AppPalette.blackClr),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}