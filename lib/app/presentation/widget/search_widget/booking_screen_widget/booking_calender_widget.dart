
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:user_panel/app/data/models/date_model.dart';
import 'package:user_panel/app/domain/usecases/data_listing_usecase.dart';
import 'package:user_panel/app/presentation/provider/bloc/fetching_bloc/fetch_slots_dates_bloc/fetch_slots_dates_bloc.dart';
import 'package:user_panel/app/presentation/provider/bloc/fetching_bloc/fetch_slots_specificdate_bloc/fetch_slots_specificdate_bloc.dart';
import 'package:user_panel/app/presentation/provider/cubit/booking_cubits/calender_picker_cubit.dart/calender_picker_cubit.dart';
import 'package:user_panel/core/themes/colors.dart';
import 'package:user_panel/core/utils/constant/constant.dart';

class BookingCalenderBlocBuilder extends StatelessWidget {
  final String barberId;
  const BookingCalenderBlocBuilder({
    super.key,
    required this.barberId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalenderPickerCubit, CalenderPickerState>(
      builder: (context, calenderState) {
        return BlocBuilder<FetchSlotsDatesBloc, FetchSlotsDatesState>(
          builder: (context, dateState) {
            if (dateState is FetchSlotsDatesSuccess) {
              final List<DateModel> availableDates = dateState.dates;
              final Set<DateTime> enabledDates = availableDates
                  .map((dateModel) => parseDate(dateModel.date))
                  .toSet();

              return Column(
                children: [
                  TableCalendar(
                    focusedDay: calenderState.selectedDate,
                    firstDay: DateTime.now(),
                    lastDay: DateTime(
                      DateTime.now().year + 3,
                      DateTime.now().month,
                      DateTime.now().day,
                    ),
                    calendarFormat: CalendarFormat.month,
                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Month'
                    },
                    selectedDayPredicate: (day) {
                      return isSameDay(calenderState.selectedDate, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      if (enabledDates.contains(DateTime(selectedDay.year,
                          selectedDay.month, selectedDay.day))) {
                        context
                            .read<CalenderPickerCubit>()
                            .updateSelectedDate(selectedDay);
                        context.read<FetchSlotsSpecificdateBloc>().add(
                            FetchSlotsSpecificdateRequst(
                                barberId: barberId, selectedDate: selectedDay));
                      }
                    },
                    calendarStyle: CalendarStyle(
                        selectedDecoration: BoxDecoration(
                          color: AppPalette.orengeClr,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: AppPalette.buttonClr,
                          shape: BoxShape.circle,
                        ),
                        todayTextStyle: TextStyle(
                          color: AppPalette.whiteClr,
                          fontWeight: FontWeight.bold,
                        ),
                        defaultDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        outsideDaysVisible: false,
                        defaultTextStyle:
                            TextStyle(fontWeight: FontWeight.w900)),
                    calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) {
                      final isEnable = enabledDates
                          .contains(DateTime(day.year, day.month, day.day));

                      if (!isEnable) {
                        return Center(
                            child: Text('${day.day}',
                                style: TextStyle(color: AppPalette.greyClr)));
                      }
                      return Center(
                          child: Text('${day.day}',
                              style: TextStyle(
                                  color: AppPalette.blackClr,
                                  fontWeight: FontWeight.w900)));
                    }),
                  ),
                  ConstantWidgets.hight10(context),
                ],
              );
            }
            return Shimmer.fromColors(
              baseColor: Colors.grey[300] ?? AppPalette.greyClr,
              highlightColor: AppPalette.whiteClr,
              child: TableCalendar(
                focusedDay: calenderState.selectedDate,
                firstDay: DateTime.now(),
                lastDay: DateTime(
                  DateTime.now().year + 3,
                  DateTime.now().month,
                  DateTime.now().day,
                ),
                calendarFormat: CalendarFormat.month,
                availableCalendarFormats: const {CalendarFormat.month: 'Month'},
                calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                        color: AppPalette.greyClr, shape: BoxShape.circle),
                    todayDecoration: BoxDecoration(
                        color: AppPalette.greyClr, shape: BoxShape.circle),
                    todayTextStyle: TextStyle(
                        color: AppPalette.whiteClr,
                        fontWeight: FontWeight.bold),
                    defaultDecoration: BoxDecoration(shape: BoxShape.circle),
                    outsideDaysVisible: false),
              ),
            );
          },
        );
      },
    );
  }
}
