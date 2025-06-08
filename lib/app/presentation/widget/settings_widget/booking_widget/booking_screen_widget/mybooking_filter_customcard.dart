
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/app/presentation/provider/bloc/fetching_bloc/fetch_booking_with_barber_bloc/fetch_booking_with_barber_bloc.dart';

import '../../../../../../core/themes/colors.dart';
import 'mybooking_filter_card.dart';

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
                context.read<FetchBookingWithBarberBloc>().add(FetchBookingWithBarberFileterRequest(filtering: 'Completed'));
              },
            ),
            VerticalDivider(color: AppPalette.hintClr),
            BookingFilteringCards(
              label: 'Cancelled',
              icon: Icons.free_cancellation_rounded,
              colors: AppPalette.redClr,
              onTap: () {
                 context.read<FetchBookingWithBarberBloc>().add(FetchBookingWithBarberFileterRequest(filtering: 'Cancelled'));
              },
            ),
            VerticalDivider(color: AppPalette.hintClr),
            BookingFilteringCards(
              label: 'Pending',
              icon: Icons.pending_actions_rounded,
              colors: AppPalette.orengeClr,
              onTap: () {
                 context.read<FetchBookingWithBarberBloc>().add(FetchBookingWithBarberFileterRequest(filtering: 'Pending'));
              },
            ),
          ],
        ),
      ),
    );
  }
}