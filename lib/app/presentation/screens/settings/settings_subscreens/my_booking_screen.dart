import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_panel/core/common/custom_appbar_widget.dart';
import 'package:user_panel/core/themes/colors.dart';

import '../../../../../core/utils/constant/constant.dart';
import '../../../../data/repositories/fetch_booking_transaction_repo.dart';
import '../../../provider/bloc/fetching_bloc/fetch_booking_bloc/fetch_booking_bloc.dart';
import '../../pages/home/wallet_screen/wallet_sreen.dart';

class MyBookingScreen extends StatelessWidget {
  const MyBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FetchBookingBloc(FetchBookingRepositoryImpl()),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;

          return ColoredBox(
            color: AppPalette.hintClr,
            child: SafeArea(
              child: Scaffold(
                appBar: CustomAppBar(),
                body: MyBookingWidgets(screenWidth: screenWidth, screenHeight: screenHeight),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MyBookingWidgets extends StatefulWidget {
  const MyBookingWidgets({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  final double screenWidth;
  final double screenHeight;

  @override
  State<MyBookingWidgets> createState() => _MyBookingWidgetsState();
}

class _MyBookingWidgetsState extends State<MyBookingWidgets> {
    @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchBookingBloc>().add(FetchBookingDatsRequest());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: widget.screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Bookings',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ConstantWidgets.hight10(context),
              Text(
                'Stay on top of your schedule — check the status of every booking and review all your appointment details anytime.',
              ),
              ConstantWidgets.hight20(context),
              MybookingFilteringCards(
                screenWidth: widget.screenWidth,
                screenHeight: widget.screenHeight,
              ),
              ConstantWidgets.hight20(context),
            ],
          ),
        ),
        Expanded(
          child: MyBookingListWIdget(screenWidth: widget.screenWidth, screenHeight: widget.screenHeight),
        ),
      ],
    );
  }
}

class MyBookingListWIdget extends StatelessWidget {
  const MyBookingListWIdget({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: AppPalette.whiteClr,
      color: AppPalette.buttonClr,
      onRefresh: () async {
        context.read<FetchBookingBloc>().add(FetchBookingDatsRequest());
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child: Column(
          children: [
            BlocBuilder<FetchBookingBloc, FetchBookingState>(
              builder: (context, state) {
                if (state is FetchBookingLoading) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300] ?? AppPalette.greyClr,
                    highlightColor: AppPalette.whiteClr,
                    child: SizedBox(
                      height: screenHeight * 0.5,
                      child: ListView.separated(
                        separatorBuilder: (context, index) =>
                            ConstantWidgets.hight10(context),
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return TrasactionCardsWalletWidget(
                            ontap: () {},
                            screenHeight: screenHeight,
                            mainColor: AppPalette.hintClr,
                            amount: '+ ₹500.00',
                            amountColor: AppPalette.greyClr,
                            status: 'Loading..',
                            statusIcon: Icons.check_circle_outline_outlined,
                            id: 'Transaction #${index + 1}',
                            stusColor: AppPalette.greyClr,
                            dateTime: DateTime.now().toString(),
                            method: 'Online Banking',
                            description:
                                "Sent: Online Banking transfer of ₹500.00",
                          );
                        },
                      ),
                    ),
                  );
                } else if (state is FetchBookingEmpty) {
                  return Center(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.calendar),
                          Text("Your booking history will appear here once you make a reservation."),
                          Text("No bookings found yet!",style: TextStyle(color: AppPalette.orengeClr))
                        ]),
                  );
                } else if (state is FetchBookingSuccess) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: state.bookings.length,
                    separatorBuilder: (_, __) =>
                        ConstantWidgets.hight10(context),
                    itemBuilder: (context, index) {
                      final booking = state.bookings[index];
                      final isDebited =
                          booking.transaction.toLowerCase().contains('debited');

                      return TrasactionCardsWalletWidget(
                        ontap: () {},
                        screenHeight: screenHeight,
                        amount: isDebited
                            ? '- ₹${booking.amountPaid.toStringAsFixed(2)}'
                            : '+ ₹${booking.amountPaid.toStringAsFixed(2)}',
                        amountColor:
                            isDebited ? AppPalette.redClr : AppPalette.greenClr,
                        dateTime: DateFormat('dd/MM/yyyy').format(booking.createdAt),
                        description:"Booked ${booking.serviceType.length} services and ${booking.slotTime.length} slots",
                        id: 'OTP: ${booking.otp}',
                        method: booking.paymentMethod,
                        status: booking.serviceStatus,
                        statusIcon: switch (booking.serviceStatus.toLowerCase()) {
                          'completed' => Icons.check_circle_outline_outlined,
                          'pending' => Icons.pending_actions_rounded,
                          'cancelled' => Icons.free_cancellation_rounded,
                          _ => Icons.help_outline,
                        },
                        stusColor: switch (booking.serviceStatus.toLowerCase()) {
                          'completed' => AppPalette.greenClr,
                          'pending' => AppPalette.orengeClr,
                          'cancelled' => AppPalette.redClr,
                         _ => AppPalette.hintClr,                  
                          }
                      
                      );
                    },
                  );
                }

                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.swap_horiz),
                      Text(
                          "Oops! Something went wrong. We're having trouble processing your request. Please try again."),
                      InkWell(
                          onTap: () async {
                            context
                                .read<FetchBookingBloc>()
                                .add(FetchBookingDatsRequest());
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.refresh,
                                color: AppPalette.blueClr,
                              ),
                              ConstantWidgets.width20(context),
                              Text("Refresh",
                                  style: TextStyle(
                                      color: AppPalette.blueClr,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ))
                    ]);
              },
            ),
            ConstantWidgets.hight20(context)
          ],
        ),
      ),
    );
  }
}

class BookingFilteringCards extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color colors;

  const BookingFilteringCards({
    super.key,
    required this.label,
    required this.icon,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              ConstantWidgets.width20(context),
              Icon(
                icon,
                color: colors,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MybookingFilteringCards extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const MybookingFilteringCards({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHeight * 0.048,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            BookingFilteringCards(
              label: 'All Booking',
              icon: Icons.history_rounded,
              colors: Colors.black,
              onTap: () {
                 context.read<FetchBookingBloc>().add(FetchBookingDatsRequest());
              },
            ),
            VerticalDivider(color: AppPalette.hintClr),
            BookingFilteringCards(
              label: 'Completed',
              icon: Icons.check_circle_outline_sharp,
              colors: Colors.green,
              onTap: () {
                 context.read<FetchBookingBloc>().add(FetchBookingDataFilteringBooking(fillterText: 'completed'));
              },
            ),
            VerticalDivider(color: AppPalette.hintClr),
            BookingFilteringCards(
              label: 'Cancelled',
              icon: Icons.free_cancellation_rounded,
              colors: AppPalette.redClr,
              onTap: () {
                  context.read<FetchBookingBloc>().add(FetchBookingDataFilteringBooking(fillterText: 'cancelled'));
              },
            ),
            VerticalDivider(color: AppPalette.hintClr),
            BookingFilteringCards(
              label: 'Pending',
              icon: Icons.pending_actions_rounded,
              colors: AppPalette.orengeClr,
              onTap: () {
                  context.read<FetchBookingBloc>().add(FetchBookingDataFilteringBooking(fillterText: 'pending'));
              },
            ),
          ],
        ),
      ),
    );
  }
}
