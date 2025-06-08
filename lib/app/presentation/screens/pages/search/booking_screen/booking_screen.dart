import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_panel/app/presentation/provider/bloc/fetching_bloc/fetch_slots_specificdate_bloc/fetch_slots_specificdate_bloc.dart';
import 'package:user_panel/app/presentation/provider/cubit/booking_cubits/date_selection_cubit/date_selection_cubit.dart';
import 'package:user_panel/app/presentation/provider/cubit/booking_cubits/service_selection_cubit/service_selection_cubit.dart';
import 'package:user_panel/app/presentation/screens/pages/search/payment_screen/payment_screen.dart';
import 'package:user_panel/app/presentation/widget/search_widget/booking_screen_widget/booking_body_widget.dart';
import 'package:user_panel/core/common/custom_appbar_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/core/common/custom_snackbar_widget.dart';
import '../../../../../../core/common/custom_actionbutton_widget.dart';
import '../../../../../../core/themes/colors.dart';
import '../../../../../../core/utils/constant/constant.dart';
import '../../../../../data/repositories/fetch_barber_slots_dates.dart';
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




