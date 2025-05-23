
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/app/presentation/widget/settings_widget/booking_widget/my_booking_detail_widget/detail_list_widget.dart';
import 'package:user_panel/core/themes/colors.dart';

import '../../../../../../core/utils/constant/constant.dart';
import '../../../../provider/bloc/fetching_bloc/fetch_specific_booking_bloc/fetch_specific_booking_bloc.dart';

class MyBookingDetailScreenWidget extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final String userId;
  final String bookingId;

  const MyBookingDetailScreenWidget({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.userId,
    required this.bookingId,
  });

  @override
  State<MyBookingDetailScreenWidget> createState() =>
      _MyBookingDetailScreenWidgetState();
}

class _MyBookingDetailScreenWidgetState
    extends State<MyBookingDetailScreenWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<FetchSpecificBookingBloc>()
          .add(FetchSpecificBookingRequest(docId: widget.bookingId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchSpecificBookingBloc, FetchSpecificBookingState>(
      builder: (context, state) {
        if (state is FetchSpecificBookingLoading) {
          return  Center(child: CircularProgressIndicator(color: AppPalette.orengeClr,));
        } else if (state is FetchSpecificBookingLoaded) {
          return MyBookingDetailsScreenListsWidget(
            screenHight: widget.screenHeight,
            screenWidth: widget.screenWidth,
            model: state.booking,
          );
        } 
           return Container(
             width: widget.screenWidth,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: AppPalette.whiteClr),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstantWidgets.hight50(context),
              Icon(CupertinoIcons.calendar_badge_minus),
              Text('Something went wrong while processing booking request.'),
              Text( 'Please try again later.',style: TextStyle(color: AppPalette.redClr),),
              ConstantWidgets.hight20(context),
            ],
          ),
          );
        
      },
    );
  }
}
