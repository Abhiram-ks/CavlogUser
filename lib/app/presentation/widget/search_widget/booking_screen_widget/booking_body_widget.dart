
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/app/presentation/provider/bloc/fetching_bloc/fetch_barber_details_bloc/fetch_barber_details_bloc.dart';
import 'package:user_panel/app/presentation/provider/bloc/fetching_bloc/fetch_slots_dates_bloc/fetch_slots_dates_bloc.dart';
import 'package:user_panel/app/presentation/provider/bloc/fetching_bloc/fetch_slots_specificdate_bloc/fetch_slots_specificdate_bloc.dart';
import 'package:user_panel/app/presentation/provider/cubit/booking_cubits/calender_picker_cubit.dart/calender_picker_cubit.dart';
import 'package:user_panel/app/presentation/widget/search_widget/booking_screen_widget/booking_calender_widget.dart';
import 'package:user_panel/app/presentation/widget/search_widget/booking_screen_widget/booking_color_indicator.dart';
import 'package:user_panel/app/presentation/widget/search_widget/booking_screen_widget/booking_service_builder.dart';
import 'package:user_panel/app/presentation/widget/search_widget/booking_screen_widget/booking_slot_builder.dart';
import 'package:user_panel/core/utils/constant/constant.dart';

import '../../../../../core/themes/colors.dart';

class BookinScreenWidgets extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final String barberid;

  const BookinScreenWidgets(
      {super.key,
      required this.screenWidth,
      required this.screenHeight,
      required this.barberid});

  @override
  State<BookinScreenWidgets> createState() => _BookinScreenWidgetsState();
}

class _BookinScreenWidgetsState extends State<BookinScreenWidgets> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchSlotsDatesBloc>().add(FetchSlotsDateRequest(barberId: widget.barberid));
      context.read<FetchBarberDetailsBloc>().add(FetchBarberServicesRequested(widget.barberid));
      _fetchSlotsForToday();
    });
  }

  void _fetchSlotsForToday() {
    final selectedDate = context.read<CalenderPickerCubit>().state.selectedDate;
    context.read<FetchSlotsSpecificdateBloc>().add(FetchSlotsSpecificdateRequst(barberId: widget.barberid, selectedDate: selectedDate));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BookingCalenderBlocBuilder(
          barberId: widget.barberid,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstantWidgets.hight10(context),
              Text('Choose Service',
                  style: TextStyle(fontWeight: FontWeight.w900)),
              BookingServiceBuilder(),
              ConstantWidgets.hight10(context),
               Text('Status Indicators', style: TextStyle(fontWeight: FontWeight.w900)),
                 SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      colorMarker(context: context,hintText: 'Reserve Time',markColor: AppPalette.buttonClr),
                      colorMarker(context: context,hintText: 'Active Slots',markColor: AppPalette.whiteClr),
                      colorMarker(context: context,hintText: 'Disabled Slots',markColor:const Color.fromARGB(255, 237, 237, 238)),
                      colorMarker(context: context,hintText: 'Booked Slots',markColor: AppPalette.hintClr),
                    ],
                  ),
                ),
             ConstantWidgets.hight10(context),
              Text('Available time', style: TextStyle(fontWeight: FontWeight.w900)),
              BookingSlotBuilder(),
            ],
          ),
        ),
        ConstantWidgets.hight50(context),
        ConstantWidgets.hight30(context)
      ],
    );
  }
}
