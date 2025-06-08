
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_panel/app/domain/usecases/data_listing_usecase.dart';
import 'package:user_panel/app/presentation/provider/bloc/fetching_bloc/fetch_slots_specificdate_bloc/fetch_slots_specificdate_bloc.dart';
import 'package:user_panel/app/presentation/provider/cubit/booking_cubits/date_selection_cubit/date_selection_cubit.dart';
import 'package:user_panel/app/presentation/provider/cubit/booking_cubits/service_selection_cubit/service_selection_cubit.dart';
import 'package:user_panel/app/presentation/widget/search_widget/booking_screen_widget/booking_chips_maker.dart';
import 'package:user_panel/core/themes/colors.dart';
import 'package:user_panel/core/utils/constant/constant.dart';

class BookingSlotBuilder extends StatelessWidget {
  const BookingSlotBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchSlotsSpecificdateBloc,FetchSlotsSpecificDateState>(builder: (context, state) {
      if (state is FetchSlotsSpecificDateEmpty) {
        final String date = formatDate(state.salectedDate);
         return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ConstantWidgets.hight20(context),
              Icon(Icons.cloud_off_outlined, color: AppPalette.blackClr,size: 50,),
              Text( date),
              Text('No slots are available at the moment'),
              ConstantWidgets.hight30(context),
            ],
          ),
        );
      } else if (state is FetchSlotsSpecificDateFailure) {
                         return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ConstantWidgets.hight20(context),
              Icon(Icons.timer_off, color: AppPalette.redClr,size: 30,),
                Text("Oop's Unable to complete the request.",style: TextStyle(fontWeight: FontWeight.bold)),
               Text('Please try again later.',),
               ConstantWidgets.hight30(context)
            ],
          ),
        );
      } 
      else if (state is FetchSlotsSpecificDateLoading) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300] ?? AppPalette.greyClr,
          highlightColor: AppPalette.whiteClr,
          child: Wrap(
            spacing: 4.0,
            runSpacing: 3.0,
            children: List.generate(12, (index) {
              return ClipChipMaker.build(
                text: '11:00 AM',
                actionColor: AppPalette.hintClr,
                textColor: AppPalette.blackClr,
                backgroundColor:
                    AppPalette.scafoldClr ?? AppPalette.hintClr,
                borderColor: AppPalette.hintClr,
                onTap: () {},
              );
            }),
          ),
        );
      }
      if (state is FetchSlotsSpecificDateLoaded) {
        final slots = state.slots;
        final slotSelectionCubit =  context.watch<SlotSelectionCubit>();
        final maxSelectableSlots = context
            .watch<ServiceSelectionCubit>()
            .state
            .selectedServices
            .length;
    
        return Wrap(
          spacing: 3.0,
          runSpacing: 3.0,
          children: slots.map((slot) {
            final isSelected =
                slotSelectionCubit.isSlotSelected(slot.subDocId);
            String formattedStartTime =
                formatTimeRange(slot.startTime);
            final selectedSlotCount =
                slotSelectionCubit.state.selectedSlots.length;
            final bool isTimeExceeded =
                isSlotTimeExceeded(slot.docId, formattedStartTime);
    
            return ClipChipMaker.build(
              text: formattedStartTime,
              actionColor: slot.available
                  ? const Color.fromARGB(255, 237, 237, 238)
                  : AppPalette.trasprentClr,
              textColor: isSelected
                  ? AppPalette.whiteClr
                  : slot.booked
                      ? AppPalette.greyClr
                      : isTimeExceeded
                          ? AppPalette.whiteClr
                          : slot.available
                              ? AppPalette.blackClr
                              : AppPalette.whiteClr,
              backgroundColor: isSelected
                  ? AppPalette.buttonClr
                  : slot.booked
                      ? const Color.fromARGB(255, 226, 228, 231)
                      : isTimeExceeded
                          ? const Color.fromARGB(255, 236, 236, 238)
                          : slot.available
                              ? AppPalette.whiteClr
                              : AppPalette.redClr
                                  .withAlpha((0.7 * 255).toInt()),
              borderColor: isSelected
                  ? AppPalette.orengeClr
                  : slot.booked
                      ? AppPalette.hintClr
                      : isTimeExceeded
                          ? const Color.fromARGB(255, 226, 228, 231)
                          : AppPalette.hintClr,
              onTap: () {
                final bool canSelectSlot = !slot.booked &&
                    slot.available &&
                    !isTimeExceeded &&
                    maxSelectableSlots > 0 &&
                    (isSelected ||
                        selectedSlotCount < maxSelectableSlots);
                if (canSelectSlot) {
                  context .read<SlotSelectionCubit>()  .toggleSlot(slot, maxSelectableSlots);
                }
              },
            );
          }).toList(),
        );
      }
    
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ConstantWidgets.hight30(context),
            Icon(Icons.cloud_off_outlined, color: AppPalette.blackClr,size: 50,),
            Text(
              "Oop's Unable to complete the request.",
              style: TextStyle(color: AppPalette.greyClr),
            ),
            Text('Something went wrong. Try different date.')
          ],
        ),
      );
    
    });
  }
}
