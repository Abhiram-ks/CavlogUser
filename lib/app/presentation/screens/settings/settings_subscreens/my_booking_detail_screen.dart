import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/app/presentation/provider/bloc/fetching_bloc/fetch_specific_booking_bloc/fetch_specific_booking_bloc.dart';
import 'package:user_panel/core/common/custom_appbar_widget.dart';
import 'package:user_panel/core/utils/constant/constant.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../data/repositories/fetch_specific_booking_repo.dart'
    show FetchSpecificBookingRepositoryImpl;
import '../../../widget/search_widget/payment_screen_widgets/payment_top_portion_widget.dart';
import '../../../widget/settings_widget/booking_widget/my_booking_detail_widget/detail_body_widget.dart';

class MyBookingDetailScreen extends StatelessWidget {
  final String docId;
  final String barberId;
  final String userId;
  const MyBookingDetailScreen(
      {super.key,
      required this.docId,
      required this.barberId,
      required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FetchSpecificBookingBloc(FetchSpecificBookingRepositoryImpl()),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;

          return ColoredBox(
           color: AppPalette.hintClr,
            child: SafeArea(
              child: Scaffold(
                appBar: CustomAppBar(),
                body: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                  PaymentTopPortion(
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                    barberUId: barberId,
                  ),
                  ConstantWidgets.hight30(context),
                  MyBookingDetailScreenWidget(
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      userId: userId,
                      bookingId: docId),
                                      ],
                                    ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
