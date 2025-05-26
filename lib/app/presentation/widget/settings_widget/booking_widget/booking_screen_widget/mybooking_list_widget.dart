import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_panel/app/presentation/provider/bloc/fetching_bloc/fetch_booking_with_barber_bloc/fetch_booking_with_barber_bloc.dart';
import 'package:user_panel/app/presentation/screens/settings/settings_subscreens/my_booking_detail_screen.dart';
import 'package:user_panel/app/presentation/widget/home_widget/wallet_widget/wallet_transaction_card_widget.dart';

import '../../../../../../core/common/custom_lottie_widget.dart';
import '../../../../../../core/themes/colors.dart';
import '../../../../../../core/utils/constant/constant.dart';
import '../../../../../../core/utils/image/app_images.dart';
import '../../../../../domain/usecases/data_listing_usecase.dart';

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
                        separatorBuilder: (context, index) =>ConstantWidgets.hight10(context),
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
                } else if (state is FetchBookingWithBarberEmpty) {
                  return Center(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ConstantWidgets.hight50(context),
                          LottieFilesCommon.load(
                              assetPath: LottieImages.emptyData,
                              height: screenHeight * 0.35,
                              width: screenWidth * .6),
                          Text("No activity found — time to take action!",
                              style: TextStyle(color: AppPalette.blackClr))
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
                      final date = formatDate(booking.booking.createdAt);
                      final formattedStartTime =
                          formatTimeRange(booking.booking.createdAt);

                      return TrasactionCardsWalletWidget(
                          ontap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyBookingDetailScreen(
                                      docId: booking.booking.bookingId!,
                                      barberId: booking.booking.barberId,
                                      userId: booking.booking.userId),
                                ));
                          },
                          screenHeight: screenHeight,
                          amount: () {
                            final gender = booking.barber.gender?.toLowerCase();
                            if (gender == 'male') return 'Male';
                            if (gender == 'female') return 'Female';
                            return 'Unisex';
                          }(),
                          amountColor: (() {
                            final gender = booking.barber.gender?.toLowerCase();
                            if (gender == 'male') return AppPalette.blueClr;
                            if (gender == 'female') return Colors.pink;
                            return AppPalette.orengeClr;
                          })(),
                          dateTime: '$date At $formattedStartTime',
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
