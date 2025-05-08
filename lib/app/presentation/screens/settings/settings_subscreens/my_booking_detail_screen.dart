import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_panel/app/data/models/booking_model.dart';
import 'package:user_panel/app/presentation/provider/bloc/fetching_bloc/fetch_specific_booking_bloc/fetch_specific_booking_bloc.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constant/constant.dart';
import '../../../../data/repositories/fetch_specific_booking_repo.dart' show FetchSpecificBookingRepositoryImpl;
import '../../../../domain/usecases/data_listing_usecase.dart';
import '../../../widget/search_widget/booking_screen_widget/booking_chips_maker.dart';
import '../../../widget/search_widget/payment_screen_widgets/payment_top_portion_widget.dart';
import '../../pages/search/payment_screen/payment_screen.dart';

class MyBookingDetailScreen extends StatelessWidget {
  final String docId;
  final String barberId;
  final String userId;
  const MyBookingDetailScreen(
      {super.key,
      required this.docId,
      required this.barberId,
      required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FetchSpecificBookingBloc(FetchSpecificBookingRepositoryImpl()),
      child: LayoutBuilder(
        builder: (context, constraints) {
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
                      barberUId: barberId,
                    ),
                    MyBookingDetailScreenWidget(
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                        userId: userId,
                        bookingId: docId),
                  ],
                )),
              ),
            ),
          );
        },
      ),
    );
  }
}



class MyBookingDetailScreenWidget extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final String userId;
  final String bookingId;

  const MyBookingDetailScreenWidget({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.userId,
    required this.bookingId,
  });

  @override
  State<MyBookingDetailScreenWidget> createState() =>
      _MyBookingDetailScreenWidgetState();
}

class _MyBookingDetailScreenWidgetState
    extends State<MyBookingDetailScreenWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<FetchSpecificBookingBloc>()
          .add(FetchSpecificBookingRequest(docId: widget.bookingId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchSpecificBookingBloc, FetchSpecificBookingState>(
      builder: (context, state) {
        if (state is FetchSpecificBookingLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FetchSpecificBookingLoaded) {
          return MyBookingDetailsScreenListsWidget(
            screenHight: widget.screenHeight,
            screenWidth: widget.screenWidth,
            model: state.booking,
          );
        } else if (state is FetchSpecificBookingFailure) {
          return Center(child: Text("Error: ${state.errorMessage}"));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}



class MyBookingDetailsScreenListsWidget extends StatelessWidget {
  final double screenWidth;
   final BookingModel model;
  final double screenHight;
  const MyBookingDetailsScreenListsWidget({
    super.key, required this.screenWidth, required this.screenHight, 
  required this.model,
  });


  @override
  Widget build(BuildContext context) {
    final double totalServiceAmount = model.serviceType.values.fold(0.0, (sum, value) => sum + value);
    final double platformFee = calculatePlatformFee(totalServiceAmount); 
    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: AppPalette.whiteClr),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * .04,
            vertical: screenHight * .03),
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
              "Your appointment has been successfully scheduled for ${model.slotTime.length} slot(s). Below are the date(s) and time(s):",
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
    
            ),
             SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: 5.0,
                runSpacing: 5.0,
                children: model.slotTime.map((slot) {
                  final formattedDate =  formatDate(slot);
                  String formattedStartTime = formatTimeRange(slot);

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
                Text('Service(s) Included',
                    style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                overflow: TextOverflow.ellipsis),
              ],
            ),
            ConstantWidgets.hight10(context),
            Text(
              "${model.serviceType.length} service(s) confirmed for your appointment",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
         SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Wrap(
    spacing: 5.0,
    runSpacing: 5.0,
    children: model.serviceType.entries.map((entry) {
      final String serviceName = entry.key;
      final double serviceAmount = entry.value;

      return ClipChipMaker.build(
        text: '$serviceName - ₹${serviceAmount.toStringAsFixed(0)}',
        actionColor: const Color.fromARGB(255, 239, 241, 246),
        textColor: AppPalette.blackClr,
        backgroundColor: AppPalette.whiteClr,
        borderColor: AppPalette.hintClr,
        onTap: () {},
      );
    }).toList(),
  ),
), ConstantWidgets.hight10(context),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Supplementary Info',
                    style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
             paymentSummaryTextWidget(
                context: context,
                prefixText: 'Time Required(minutes)',
                prefixTextStyle: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w500, color: AppPalette.blueClr),
                suffixText: model.duration.toString(),
                suffixTextStyle: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w500, color: AppPalette.blackClr),
              ),
              paymentSummaryTextWidget(
                context: context,
                prefixText: 'Payment Method',
                prefixTextStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w500, color: AppPalette.blackClr),
                suffixText: model.paymentMethod,
                suffixTextStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w500, color: AppPalette.blackClr),
              ),
               paymentSummaryTextWidget(
                context: context,
                prefixText: 'Payment Status',
                prefixTextStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w500, color: () {
                            final status = model.status.toLowerCase();
                            if (status == 'completed') return  AppPalette.greenClr;
                            if (status == 'cancelled') return AppPalette.redClr;
                            if (status == 'pending') return AppPalette.orengeClr;
                          }()),
                suffixText: model.status,
                suffixTextStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w500, color: AppPalette.blackClr),
              ),
               paymentSummaryTextWidget(
                context: context,
                prefixText: 'Money Flow',
                prefixTextStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w500, color: () {
                            final status = model.transaction.toLowerCase();
                            if (status == 'credited') return  AppPalette.greenClr;
                            if (status == 'debited') return AppPalette.redClr;
                          }()),
                suffixText: model.transaction,
                suffixTextStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w500, color: AppPalette.blackClr),
              ),
              paymentSummaryTextWidget(
                context: context,
                prefixText: 'Booking State',
                prefixTextStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w500, color: () {
                            final status = model.serviceStatus.toLowerCase();
                            if (status == 'completed') return  AppPalette.greenClr;
                            if (status == 'cancelled') return AppPalette.redClr;
                            if (status == 'pending') return AppPalette.orengeClr;
                          }()),
                suffixText: model.serviceStatus,
                suffixTextStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w500, color: AppPalette.blackClr),
              ),paymentSummaryTextWidget(
                context: context,
                prefixText: 'OTP',
                prefixTextStyle: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold, color: AppPalette.blackClr),
                suffixText: model.otp,
                suffixTextStyle: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold, color: AppPalette.blackClr),
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
                ...model.serviceType.entries.map((entry) {
               final String serviceName = entry.key;
               final double serviceAmount = entry.value;


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
              Divider(color: AppPalette.hintClr ),
              paymentSummaryTextWidget(
                context: context,
                prefixText: 'Total price',
                prefixTextStyle: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w500, color: AppPalette.greenClr),
                suffixText: '₹ ${model.amountPaid.toStringAsFixed(2)}',
                suffixTextStyle: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w500, color: AppPalette.blackClr),
              ),
              ],
            ),ConstantWidgets.hight30(context)
          ],
        ),
      ),
    );
  }
}
