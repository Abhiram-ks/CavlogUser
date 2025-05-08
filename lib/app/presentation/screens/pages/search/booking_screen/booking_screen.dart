import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_panel/app/presentation/provider/bloc/fetching_bloc/fetch_slots_specificdate_bloc/fetch_slots_specificdate_bloc.dart';
import 'package:user_panel/app/presentation/provider/cubit/booking_cubits/date_selection_cubit/date_selection_cubit.dart';
import 'package:user_panel/app/presentation/provider/cubit/booking_cubits/service_selection_cubit/service_selection_cubit.dart';
import 'package:user_panel/app/presentation/screens/pages/search/payment_screen/payment_screen.dart';
import 'package:user_panel/app/presentation/widget/search_widget/booking_screen_widget/booking_chips_maker.dart';
import 'package:user_panel/core/common/custom_appbar_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:user_panel/core/common/custom_snackbar_widget.dart';
import '../../../../../../core/common/custom_actionbutton_widget.dart';
import '../../../../../../core/themes/colors.dart';
import '../../../../../../core/utils/constant/constant.dart';
import '../../../../../data/models/date_model.dart';
import '../../../../../data/repositories/fetch_barber_slots_dates.dart';
import '../../../../../domain/usecases/data_listing_usecase.dart';
import '../../../../provider/bloc/fetching_bloc/fetch_barber_details_bloc/fetch_barber_details_bloc.dart';
import '../../../../provider/bloc/fetching_bloc/fetch_slots_dates_bloc/fetch_slots_dates_bloc.dart';
import '../../../../provider/cubit/booking_cubits/calender_picker_cubit.dart/calender_picker_cubit.dart';

class BookingScreen extends StatelessWidget {
  final String shopId;
  const BookingScreen({super.key, required this.shopId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ServiceSelectionCubit()),
        BlocProvider(create: (_) => SlotSelectionCubit()),
        BlocProvider(create: (_) => CalenderPickerCubit()),
        BlocProvider(create: (_) => FetchSlotsSpecificdateBloc(FetchSlotsRepositoryImpl())),
        BlocProvider(create: (_) => FetchSlotsDatesBloc(FetchSlotsRepositoryImpl()))
      ],
      child: LayoutBuilder(builder: (context, constraints) {
        double screenHeight = constraints.maxHeight;
        double screenWidth = constraints.maxWidth;
        return ColoredBox(
          color: AppPalette.hintClr,
          child: SafeArea(
           child: Scaffold(
            appBar: CustomAppBar(),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Book Appointment',
                      style: GoogleFonts.plusJakartaSans( fontSize: 28, fontWeight: FontWeight.bold)),
                      ConstantWidgets.hight10(context),
                      Text('Almost there! Pick a date, choose services, select a time slot, and proceed to payment.'),
                      ConstantWidgets.hight10(context),
                    ],
                  ),
                ),
                BookinScreenWidgets(
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    barberid: shopId)
              ]),
            ),
            floatingActionButtonLocation:FloatingActionButtonLocation.centerFloat,
            floatingActionButton: SizedBox(
                width: screenWidth * 0.9,
                child: ButtonComponents.actionButton(
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    label: 'Deal booking',
                    onTap: () {
                      final selectedServices = context.read<ServiceSelectionCubit>().state.selectedServices;
                      final selectedSlots = context.read<SlotSelectionCubit>().state.selectedSlots;
                      final slotSelectionCubit = context.read<SlotSelectionCubit>();

                      if (selectedSlots.length != selectedServices.length  || selectedSlots.isEmpty || selectedServices.isEmpty) {
                        CustomeSnackBar.show(
                            context: context,
                            title: 'Session Error Detected!',
                            description:'Oops! It looks like there was a mistake. Select the appropriate services and choose a valid time slot.',
                            titleClr: AppPalette.blackClr);
                           return;
                      }
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(barberUid: shopId, selectedSlots: selectedSlots, selectedServices: selectedServices,slotSelectionCubit:  slotSelectionCubit,)));
                      context.read<SlotSelectionCubit>().clearSlots();
                    })),
          )),
        );
      }),
    );
  }
}


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
    context.read<FetchSlotsSpecificdateBloc>().add(FetchSlotsSpecificdateRequst(
        barberId: widget.barberid, selectedDate: selectedDate));
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
              BlocBuilder<FetchBarberDetailsBloc, FetchBarberDetailsState>(
                builder: (context, state) {
                  if (state is FetchBarberServicesEmpty) {
                    return Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.face_retouching_natural),
                          ConstantWidgets.width40(context),
                          Text('Still waiting for that first style.'),
                        ],
                      ),
                    );
                  } else if (state is FetchBarberServiceSuccess) {
                    final services = state.barberServices;
                    return BlocBuilder<ServiceSelectionCubit,
                        ServiceSelectionState>(
                      builder: (context, serviceState) {
                        return SizedBox(
                          height: 50,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: services.length,
                            separatorBuilder: (context, index) =>
                                ConstantWidgets.width40(context),
                            itemBuilder: (context, index) {
                              final service = services[index];
                              final isSelected = context
                                  .watch<ServiceSelectionCubit>()
                                  .isSelected(service.serviceName);
                              return ClipChipMaker.build(
                                text:
                                    "${service.serviceName}   ₹ ${service.amount}",
                                actionColor: isSelected
                                    ? const Color.fromARGB(255, 227, 229, 234)
                                    : Color.fromARGB(255, 248, 239, 216),
                                textColor: AppPalette.blackClr,
                                backgroundColor: isSelected
                                    ? Color.fromARGB(255, 248, 239, 216)
                                    : AppPalette.whiteClr,
                                borderColor: isSelected
                                    ? Color(0xFFFEBA43)
                                    : AppPalette.hintClr,
                                onTap: () {
                                  context.read<ServiceSelectionCubit>().toggleSelection(service.serviceName,service.amount.toDouble());
                                },
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                  return SizedBox(
                    height: 50,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) =>
                          ConstantWidgets.width40(context),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300] ?? AppPalette.greyClr,
                          highlightColor: AppPalette.whiteClr,
                          child: ClipChipMaker.build(
                            text: 'HairCut ₹150',
                            actionColor: AppPalette.hintClr,
                            textColor: AppPalette.blackClr,
                            backgroundColor:
                                AppPalette.scafoldClr ?? AppPalette.hintClr,
                            borderColor: AppPalette.greyClr,
                            onTap: () {},
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
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
              BlocBuilder<FetchSlotsSpecificdateBloc,FetchSlotsSpecificDateState>(builder: (context, state) {
                if (state is FetchSlotsSpecificDateEmpty) {
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.timer_off, color: AppPalette.buttonClr),
                        Text(
                            '${state.salectedDate.day}/${state.salectedDate.month}/${state.salectedDate.year}'),
                        Text('No slots are available at the moment'),
                      ],
                    ),
                  );
                } else if (state is FetchSlotsSpecificDateFailure) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.timer_off, color: AppPalette.redClr),
                        Text('Unexpected error occurred'),
                        Text('${state.errorMessage}. Please try again!'),
                      ],
                    ),
                  );
                } else if (state is FetchSlotsSpecificDateLoading) {
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
                  final serviceSelectionState =  context.watch<ServiceSelectionCubit>().state;
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
                      Icon(Icons.search, color: AppPalette.buttonClr),
                      Text(
                        'Searching ...',
                        style: TextStyle(color: AppPalette.greyClr),
                      ),
                      Text('Oops! Something went wrong. Try different date.')
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        ConstantWidgets.hight50(context),
        ConstantWidgets.hight30(context)
      ],
    );
  }
}

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


Row colorMarker(
    {required BuildContext context,
    required Color markColor,
    required String hintText}) {
  return Row(children: [
    Container(
        width: 15,
        height: 15,
        decoration: BoxDecoration(
          color: markColor,
          shape: BoxShape.rectangle,
        )),
    ConstantWidgets.width20(context),
    Text(hintText),
    ConstantWidgets.width40(context)
  ]);
}