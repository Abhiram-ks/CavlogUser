import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_panel/app/data/models/booking_model.dart';
import 'package:user_panel/app/data/repositories/chenge_slot_status.dart';
import 'package:user_panel/core/themes/colors.dart';
import '../../../../../../core/common/custom_appbar_widget.dart';
import '../../../../../../core/utils/constant/constant.dart';
import '../../../../../data/datasources/barber_wallet_remote_datasources.dart';
import '../../../../../data/repositories/cancel_booking_repo.dart';
import '../../../../../data/repositories/refund_cancel_repo.dart';
import '../../../../provider/bloc/cancel_booking_bloc/booking_cancel_bloc.dart';
import '../../../../widget/home_widget/cancel_booking_screen_widget/cancel_booking_screen_widget.dart';
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

