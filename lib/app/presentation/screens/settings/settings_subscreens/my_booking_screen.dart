import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_panel/app/data/repositories/fetch_barber_repo.dart';
import 'package:user_panel/app/data/repositories/fetch_booking_with_barber_model.dart';
import 'package:user_panel/app/presentation/screens/settings/settings_subscreens/my_booking_detail_screen.dart';
import 'package:user_panel/core/common/custom_appbar_widget.dart';
import 'package:user_panel/core/common/custom_lottie_widget.dart';
import 'package:user_panel/core/themes/colors.dart';
import 'package:user_panel/core/utils/image/app_images.dart';
import '../../../../../core/utils/constant/constant.dart';
import '../../../provider/bloc/fetching_bloc/fetch_booking_with_barber_bloc/fetch_booking_with_barber_bloc.dart';
import '../../../widget/home_widget/wallet_screen_widget/wallet_transaction_card_widget.dart';

class MyBookingScreen extends StatelessWidget {
  const MyBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final fetchBarberRepo = FetchBarberRepositoryImpl();
        final barberService = BarberService(fetchBarberRepo);
        final repository = FetchBookingAndBarberRepositoryImpl(barberService);

        return FetchBookingWithBarberBloc(repository);
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;

          return ColoredBox(
            color: AppPalette.hintClr,
            child: SafeArea(
              child: Scaffold(
                appBar: CustomAppBar(),
                body: MyBookingWidgets( screenWidth: screenWidth, screenHeight: screenHeight),
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
      context
          .read<FetchBookingWithBarberBloc>()
          .add(FetchBookingWithBarberRequest());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.screenWidth * 0.04),
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
          child: MyBookingListWIdget(
              screenWidth: widget.screenWidth,
              screenHeight: widget.screenHeight),
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
        context.read<FetchBookingWithBarberBloc>().add(FetchBookingWithBarberRequest());
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child: Column(
          children: [
            BlocBuilder<FetchBookingWithBarberBloc,
                FetchBookingWithBarberState>(
              builder: (context, state) {
                if (state is FetchBookingWithBarberLoading) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300] ?? AppPalette.greyClr,
                    highlightColor: AppPalette.whiteClr,
                    child: SizedBox(
                      height: screenHeight * 0.8,
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
                            description: "Sent: Online Banking transfer of ₹500.00",
                          );
                        },
                      ),
                    ),
                  );
                } else if (state is FetchBookingWithBarberEmpty) {
                  return Center(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ConstantWidgets.hight50(context),
                          LottieFilesCommon.load(assetPath: LottieImages.emptyData,height: screenHeight * 0.35,width: screenWidth *.6),
                          Text("No activity found — time to take action!",style: TextStyle(color: AppPalette.blackClr))
                        ]),
                  );
                } else if (state is FetchBookingWithBarberLoaded) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: state.combo.length,
                    separatorBuilder: (_, __) =>
                        ConstantWidgets.hight10(context),
                    itemBuilder: (context, index) {
                      final booking = state.combo[index];

                      return TrasactionCardsWalletWidget(
                          ontap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MyBookingDetailScreen(docId: booking.booking.bookingId!, barberId: booking.booking.barberId, userId: booking.booking.userId),));
                          },
                          screenHeight: screenHeight,
                          amount: () {
                            final gender = booking.barber.gender?.toLowerCase();
                            if (gender == 'male') return 'Male';
                            if (gender == 'female') return 'Female';
                            return 'Unisex';
                          }(),
                          amountColor:(() {
                      final gender = booking.barber.gender?.toLowerCase();
                      if (gender == 'male') return AppPalette.blueClr;
                      if (gender == 'female') return Colors.pink;
                      return AppPalette.orengeClr;
                    })(),
                          dateTime: DateFormat('dd/MM/yyyy')
                              .format(booking.booking.createdAt),
                          description: booking.barber.ventureName,
                          id: 'Booking Code: ${booking.booking.otp}',
                          method: booking.barber.address,
                          status: booking.booking.serviceStatus,
                          statusIcon: switch (
                              booking.booking.serviceStatus.toLowerCase()) {
                            'completed' => Icons.check_circle_outline_outlined,
                            'pending' => Icons.pending_actions_rounded,
                            'cancelled' => Icons.free_cancellation_rounded,
                            _ => Icons.help_outline,
                          },
                          stusColor: switch (
                              booking.booking.serviceStatus.toLowerCase()) {
                            'completed' => AppPalette.greenClr,
                            'pending' => AppPalette.orengeClr,
                            'cancelled' => AppPalette.redClr,
                            _ => AppPalette.hintClr,
                          });
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
                                .read<FetchBookingWithBarberBloc>()
                                .add(FetchBookingWithBarberRequest());
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
                context.read<FetchBookingWithBarberBloc>().add(FetchBookingWithBarberRequest());
              },
            ),
            VerticalDivider(color: AppPalette.hintClr),
            BookingFilteringCards(
              label: 'Completed',
              icon: Icons.check_circle_outline_sharp,
              colors: Colors.green,
              onTap: () {
                context.read<FetchBookingWithBarberBloc>().add(FetchBookingWithBarberFileterRequest(filtering: 'completed'));
              },
            ),
            VerticalDivider(color: AppPalette.hintClr),
            BookingFilteringCards(
              label: 'Cancelled',
              icon: Icons.free_cancellation_rounded,
              colors: AppPalette.redClr,
              onTap: () {
                 context.read<FetchBookingWithBarberBloc>().add(FetchBookingWithBarberFileterRequest(filtering: 'cancelled'));
              },
            ),
            VerticalDivider(color: AppPalette.hintClr),
            BookingFilteringCards(
              label: 'Pending',
              icon: Icons.pending_actions_rounded,
              colors: AppPalette.orengeClr,
              onTap: () {
                 context.read<FetchBookingWithBarberBloc>().add(FetchBookingWithBarberFileterRequest(filtering: 'pending'));
              },
            ),
          ],
        ),
      ),
    );
  }
}
