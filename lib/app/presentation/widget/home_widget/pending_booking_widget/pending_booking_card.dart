import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constant/constant.dart';
import '../../../provider/cubit/auto_completed_booking_cubit/auto_complited_booking_cubit.dart';
import '../../../provider/cubit/booking_timeline-cubit/booking_timeline_cubit.dart';
import '../../../provider/cubit/booking_timeline-cubit/booking_timeline_state.dart';
import '../../search_widget/details_screen_widget/details_screen_actionbuttos.dart';
import '../../search_widget/search_screen_widget/custom_cards_barberlist.dart';

class HorizontalIconTimeline extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final VoidCallback onTapInformation;
  final VoidCallback onTapCall;
  final VoidCallback onTapDirection;
  final VoidCallback onTapCancel;
  final String imageUrl;
  final String bookingId;
  final VoidCallback onTapBarber;
  final String shopName;
  final bool isBlocked;
  final double rating;
  final String shopAddress;
  final DateTime createdAt;
  final List<DateTime> slotTimes;
  final int duration;

  const HorizontalIconTimeline(
      {super.key,
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
      required this.bookingId});

  @override
  State<HorizontalIconTimeline> createState() => _HorizontalIconTimelineState();
}

class _HorizontalIconTimelineState extends State<HorizontalIconTimeline> {
  final List<IconData> icons = [
    Icons.event,
    Icons.timer_outlined,
    Icons.cut_outlined,
    Icons.verified,
  ];

  final List<String> labels = [
    'Booked',
    'waiting',
    'InProgress',
    'Finished',
  ];

  @override
  void initState() {
    super.initState();
    context.read<TimelineCubit>().updateTimeline(
          createdAt: widget.createdAt,
          slotTimes: widget.slotTimes,
          duration: widget.duration,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppPalette.hintClr)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BlocBuilder<TimelineCubit, TimelineState>(
            builder: (context, state) {
              int currentStep = 0;
              switch (state.currentStep) {
                case TimelineStep.created:
                  currentStep = 0;
                  break;
                case TimelineStep.waiting:
                  currentStep = 1;
                  break;
                case TimelineStep.inProgress:
                  currentStep = 2;
                  break;
                case TimelineStep.completed:
                  currentStep = 3;
                  final sortedSlotTimes = List<DateTime>.from(widget.slotTimes)..sort();

                  final endTime = sortedSlotTimes.last;
                  if (DateTime.now().isAfter(endTime)) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.read<AutoComplitedBookingCubit>().completeBooking(
                            widget.bookingId,
                          );
                    });
                  }
                  break;
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(icons.length, (index) {
                      final isActive = index <= currentStep;
                      Color iconColor =
                          isActive ? AppPalette.blackClr : AppPalette.greyClr;

                      return Expanded(
                        child: Column(
                          children: [
                            Icon(icons[index], color: iconColor),
                            ConstantWidgets.hight10(context),
                            Text(
                              labels[index],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: iconColor,
                                fontWeight: isActive
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  ConstantWidgets.hight10(context),
                  Row(
                    children: List.generate(icons.length * 2 - 1, (index) {
                      if (index % 2 == 0) {
                        final stepIndex = index ~/ 2;
                        final isActive = stepIndex <= currentStep;
                        final isCurrentStep = stepIndex == currentStep;

                        return Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppPalette.orengeClr
                                : Colors.grey.shade300,
                            shape: BoxShape.circle,
                            border: isCurrentStep
                                ? Border.all(
                                    color: AppPalette.buttonClr, width: 2)
                                : null,
                          ),
                          child: Center(
                              child: isCurrentStep
                                  ? CircularProgressIndicator(
                                      color: AppPalette.orengeClr,
                                    )
                                  : null),
                        );
                      } else {
                        final lineIndex = index ~/ 2;
                        final isActive = lineIndex < currentStep;

                        return Expanded(
                          child: Container(
                            height: 3,
                            color: isActive
                                ? AppPalette.buttonClr
                                : Colors.grey.shade300,
                          ),
                        );
                      }
                    }),
                  ),
                ],
              );
            },
          ),
          ConstantWidgets.hight10(context),
          ListForBarbers(
            ontap: widget.onTapBarber,
            screenHeight: widget.screenHeight,
            screenWidth: widget.screenWidth,
            imageURl: widget.imageUrl,
            rating: widget.rating,
            shopName: widget.shopName,
            shopAddress: widget.shopAddress,
            isBlocked: widget.isBlocked,
          ),
          ConstantWidgets.hight10(context),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              detailsPageActions(
                context: context,
                screenWidth: widget.screenWidth,
                icon: CupertinoIcons.info_circle_fill,
                onTap: widget.onTapInformation,
                text: 'Details',
              ),
              detailsPageActions(
                context: context,
                screenWidth: widget.screenWidth,
                icon: Icons.phone_in_talk_rounded,
                onTap: widget.onTapCall,
                text: 'Call',
              ),
              detailsPageActions(
                context: context,
                screenWidth: widget.screenWidth,
                icon: Icons.location_on_sharp,
                onTap: widget.onTapDirection,
                text: 'Direction',
              ),
              if (context.read<TimelineCubit>().state.currentStep ==
                      TimelineStep.created ||
                  context.read<TimelineCubit>().state.currentStep ==
                      TimelineStep.waiting)
                detailsPageActions(
                  context: context,
                  colors: AppPalette.redClr,
                  screenWidth: widget.screenWidth,
                  icon: CupertinoIcons.calendar_badge_minus,
                  onTap: widget.onTapCancel,
                  text: 'Cancel',
                ),
            ],
          ),
        ],
      ),
    );
  }
}