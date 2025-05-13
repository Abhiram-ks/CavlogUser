import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_panel/app/data/models/booking_model.dart';
import 'package:user_panel/app/data/repositories/chenge_slot_status.dart';
import 'package:user_panel/app/presentation/widget/home_widget/cancel_booking_screen_widget/handle_cancel_booking_state.dart';
import 'package:user_panel/core/common/custom_bottomsheet_widget.dart';
import 'package:user_panel/core/themes/colors.dart';
import '../../../../../../auth/presentation/provider/cubit/button_progress_cubit/button_progress_cubit.dart';
import '../../../../../../auth/presentation/widget/otp_widget/otp_customform_widget.dart';
import '../../../../../../core/common/custom_actionbutton_widget.dart';
import '../../../../../../core/common/custom_appbar_widget.dart';
import '../../../../../../core/utils/constant/constant.dart';
import '../../../../../data/datasources/barber_wallet_remote_datasources.dart';
import '../../../../../data/repositories/cancel_booking_repo.dart';
import '../../../../../data/repositories/refund_cancel_repo.dart';
import '../../../../provider/bloc/cancel_booking_bloc/booking_cancel_bloc.dart';
import '../../../settings/settings_subscreens/my_booking_detail_screen.dart';

class CancelBookingScreen extends StatelessWidget {
  final BookingModel booking;
  const CancelBookingScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookingCancelBloc(
        refundRepo: RefundCancelRepositoryDatasourceImpl(),
        transactionRemoteDataSource: WalletTransactionRemoteDataSourceImpl(),
        cancelBookingRepository: CancelBookingRepositoryImpl(),
        chengeSlotStatusRepository: ChengeSlotStatusRepositoryImple()
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;

          return ColoredBox(
            color: AppPalette.hintClr,
            child: SafeArea(
                child: Scaffold(
                    appBar: const CustomAppBar(),
                    body: GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: SingleChildScrollView(
                        keyboardDismissBehavior:ScrollViewKeyboardDismissBehavior.onDrag,
                        physics: BouncingScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.07,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Booking Cancellation',
                                  style: GoogleFonts.plusJakartaSans(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold)),
                              ConstantWidgets.hight10(context),
                              Text(
                                  'Almost there! Please enter your booking Code below. If the entered Code matches the booking Code, your booking will be automatically cancelled. The refund will then be credited to your wallet shortly.'),
                              ConstantWidgets.hight10(context),
                              InkWell(
                                onTap: () {
                                   Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyBookingDetailScreen(
                                        docId: booking.bookingId!,
                                        barberId: booking.barberId,
                                        userId: booking.userId),
                                  ));
                                },
                                child: Text(
                                  "Booking Details",
                                  style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w100,
                                      color: AppPalette.blueClr),
                                ),
                              ),
                              ConstantWidgets.hight20(context),
                              BookingCalcelOtpFiled(
                                  booking: booking,
                                  screenHight: screenHeight,
                                  screenWidth: screenWidth),
                            ],
                          ),
                        ),
                      ),
                    ))),
          );
        },
      ),
    );
  }
}

class BookingCalcelOtpFiled extends StatefulWidget {
  const BookingCalcelOtpFiled(
      {super.key,
      required this.screenHight,
      required this.screenWidth,
      required this.booking});
  final BookingModel booking;
  final double screenHight;
  final double screenWidth;

  @override
  State<BookingCalcelOtpFiled> createState() => _BookingCalcelOtpFiledState();
}

class _BookingCalcelOtpFiledState extends State<BookingCalcelOtpFiled> {
  final List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());

  void onOtpChanged() {
    if (otpControllers.every((controller) => controller.text.isNotEmpty)) {
      String userOTP = getUserOTP();
      machingOTP(userOTP, context);
    }
  }

  String getUserOTP() {
    return otpControllers.map((controller) => controller.text).join();
  }

  void machingOTP(String userOTP, BuildContext context) async {
    final bookingOTP = widget.booking.otp;
    final bookingCancelBloc = context.read<BookingCancelBloc>();
    bookingCancelBloc.add(BookingOTPChecking(bookingOTP: bookingOTP, inputOTP: userOTP));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstantWidgets.hight50(context),
        ConstantWidgets.hight50(context),
        Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
                6,
                (index) => Opttextformfiled(
                    screenWidth: widget.screenWidth,
                    screenHight: widget.screenHight,
                    controller: otpControllers[index],
                    onChanged: (val) => onOtpChanged()))),
        ConstantWidgets.hight30(context),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BlocListener<BookingCancelBloc, BookingCancelState>(
              listener: (context, state) {
                handleCancelBookingState(context, state, widget.booking);
              },
              child: ButtonComponents.actionButton(
                  screenHeight: widget.screenHight,
                  screenWidth: widget.screenWidth,
                  label: 'Verify',
                  onTap: onOtpChanged,),
            ),
            ConstantWidgets.hight30(context),
            Text("Do you know our cancellation policy?"),
            InkWell(
              onTap: () {
                BottomSheetHelper().showBottomSheet(
                    context: context,
                    title: 'cancellation and refund details',
                    description:
                        'Refunds are only available if cancelled at least 30 minutes before the booking. After that, no refunds will be issued. Note: Platform fee is always non-refundable',
                    firstButtonText: 'Agree',
                    firstButtonAction: () => Navigator.pop(context),
                    firstButtonColor: AppPalette.blackClr,
                    secondButtonText: 'Go Back',
                    secondButtonAction: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    secondButtonColor: AppPalette.blackClr);
              },
              child: Text(
                'Cancellation Policy',
                style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w100, color: AppPalette.blueClr),
              ),
            )
          ],
        ),
      ],
    );
  }
}
