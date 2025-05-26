import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/app/data/repositories/fetch_barber_repo.dart';
import 'package:user_panel/app/data/repositories/fetch_booking_with_barber_model.dart';
import 'package:user_panel/core/common/custom_appbar_widget.dart';
import 'package:user_panel/core/themes/colors.dart';
import '../../../provider/bloc/fetching_bloc/fetch_booking_with_barber_bloc/fetch_booking_with_barber_bloc.dart';
import '../../../widget/settings_widget/booking_widget/booking_screen_widget/mybooking_body_widget.dart';

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



