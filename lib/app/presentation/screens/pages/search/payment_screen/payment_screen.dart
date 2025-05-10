
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_panel/app/data/datasources/barber_wallet_remote_datasources.dart';
import 'package:user_panel/app/data/datasources/booking_remote_datasources.dart';
import 'package:user_panel/app/data/repositories/slot_cheking_repo.dart';
import 'package:user_panel/app/presentation/provider/bloc/online_payment_bloc/online_payment_bloc.dart';
import 'package:user_panel/app/presentation/widget/search_widget/booking_screen_widget/booking_chips_maker.dart';
import 'package:user_panel/app/presentation/widget/search_widget/payment_screen_widgets/handle_online_payment_state.dart';
import '../../../../../../core/common/custom_actionbutton_widget.dart';
import '../../../../../../core/themes/colors.dart';
import '../../../../../../core/utils/constant/constant.dart';
import '../../../../../data/models/slot_model.dart' show SlotModel;
import '../../../../../domain/usecases/data_listing_usecase.dart';
import '../../../../provider/cubit/booking_cubits/corrency_convertion_cubit/corrency_conversion_cubit.dart';
import '../../../../provider/cubit/booking_cubits/date_selection_cubit/date_selection_cubit.dart';
import '../../../../widget/search_widget/payment_screen_widgets/payment_top_portion_widget.dart';

class PaymentScreen extends StatelessWidget {
  final String barberUid;
  final List<SlotModel> selectedSlots;
  final List<Map<String, dynamic>> selectedServices;
  final SlotSelectionCubit slotSelectionCubit;

  const PaymentScreen(
      {super.key,
      required this.barberUid,
      required this.selectedSlots,
      required this.slotSelectionCubit,
      required this.selectedServices});

  @override
  Widget build(BuildContext context) {
    final double totalAmount = getTotalServiceAmount(selectedServices);
    final double platformFee = calculatePlatformFee(totalAmount);
    final double totalInINR = totalAmount + platformFee;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: slotSelectionCubit),
        BlocProvider(create: (_) => CurrencyConversionCubit()..convertINRtoUSD(totalInINR)),
        BlocProvider(create: (_) =>OnlinePaymentBloc(bookingRemoteDatasources: BookingRemoteDatasourcesImpl(), slotCheckingRepository: SlotCheckingRepositoryImpl(), walletTransactionRemoteDataSource: WalletTransactionRemoteDataSourceImpl()) )
      ],
      child: LayoutBuilder(builder: (context, constraints) {
        double screenHeight = constraints.maxHeight;
        double screenWidth = constraints.maxWidth;

        return Scaffold(
          backgroundColor: AppPalette.whiteClr,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ColoredBox(
              color: AppPalette.orengeClr,
              child: SafeArea(
                child: Column(
                  children: [
                    PaymentTopPortion(
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      barberUId: barberUid,
                    ),
                    PaymentBottomSectionWidget(
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      selectedSlots: selectedSlots,
                      selectedServices: selectedServices,
                    )
                  ],
                ),
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: BlocBuilder<CurrencyConversionCubit, CurrencyConversionState>(
            builder: (context, convertionState) {
              String labelText = 'Loading...';
              if (convertionState is CurrencyConversionSuccess) {
                labelText = '₹${totalInINR.toStringAsFixed(2)}';
              } else if (convertionState is CurrencyConversionFailure) {
                labelText = '₹${totalInINR.toStringAsFixed(2)}';
              }
              return BlocListener<OnlinePaymentBloc, OnlinePaymentState>(
                listener: (context, state) {
                  log('now working state for online payment is : $state');
                  handleOnlinePaymentStates(context: context, state: state, totalAmount: totalInINR.toStringAsFixed(2), barberUid: barberUid, selectedServices: selectedServices,convertionState: convertionState,labelText: labelText,platformFee: platformFee,screenHeight: screenHeight,screenWidth: screenWidth,selectedSlots: selectedSlots, slotSelectionCubit:slotSelectionCubit, totalInINR: totalInINR);
                },
                child: SizedBox(
                    width: screenWidth * 0.9,
                    child: ButtonComponents.actionButton(
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      buttonColor: AppPalette.greenClr,
                      label: labelText,
                      onTap: () {
                      context.read<OnlinePaymentBloc>().add(OnlinePaymentCheckSlots(barberId: barberUid, selectedSlots: selectedSlots));

                     
                        })),
              );
            },
          ),
        );
      }),
    );
  }
}

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
                suffixText: '₹ $platformFee',
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
