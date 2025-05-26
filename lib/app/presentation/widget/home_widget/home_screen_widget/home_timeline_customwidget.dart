
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/app/data/repositories/cancel_booking_repo.dart';
import 'package:user_panel/app/presentation/provider/cubit/auto_completed_booking_cubit/auto_complited_booking_cubit.dart';
import 'package:user_panel/app/presentation/provider/cubit/booking_timeline-cubit/booking_timeline_cubit.dart';
import 'package:user_panel/app/presentation/widget/home_widget/pending_booking_widget/pending_booking_card.dart' show HorizontalIconTimeline;

class HorizontalIconTimelineHelper extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final VoidCallback onTapInformation;
  final VoidCallback onTapCall;
  final VoidCallback onTapDirection;
  final VoidCallback onTapCancel;
  final String imageUrl;
  final VoidCallback onTapBarber;
  final String shopName;
  final bool isBlocked;
  final double rating;
  final String shopAddress;
  final DateTime createdAt;
  final String bookingId;
  final List<DateTime> slotTimes;
  final int duration;

  const HorizontalIconTimelineHelper({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.onTapInformation,
    required this.onTapCall,
    required this.onTapDirection,
    required this.onTapCancel,
    required this.imageUrl,
    required this.onTapBarber,
    required this.shopName,
    required this.rating,
    required this.isBlocked,
    required this.shopAddress,
    required this.createdAt,
    required this.slotTimes,
    required this.duration,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => TimelineCubit()
            ..updateTimeline(
              createdAt: createdAt,
              slotTimes: slotTimes,
              duration: duration,
            ),
        ),
        BlocProvider(
            create: (_) => AutoComplitedBookingCubit(CancelBookingRepositoryImpl()))
      ],
      child: HorizontalIconTimeline(
          bookingId: bookingId,
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          onTapInformation: onTapInformation,
          onTapCall: onTapCall,
          onTapDirection: onTapDirection,
          onTapCancel: onTapCancel,
          imageUrl: imageUrl,
          onTapBarber: onTapBarber,
          shopName: shopName,
          rating: rating,
          isBlocked: isBlocked,
          shopAddress: shopAddress,
          createdAt: createdAt,
          slotTimes: slotTimes,
          duration: duration),
    );
  }
}
