
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/app/data/models/booking_model.dart';

import '../../../../../auth/presentation/provider/cubit/button_progress_cubit/button_progress_cubit.dart';
import '../../../../../core/common/custom_snackbar_widget.dart';
import '../../../../../core/themes/colors.dart';
import '../../../provider/bloc/cancel_booking_bloc/booking_cancel_bloc.dart';

void handleCancelBookingState( BuildContext context, BookingCancelState state, BookingModel booking){
  final buttonCubit = context.read<ButtonProgressCubit>();

  if (state is BookingOPTNotMaching) {
    buttonCubit.stopLoading();
      CustomeSnackBar.show(
      context: context,
      title: "Code Mismatch Detected!" ,
      description: "Oops! The entered OTP does Code match the booking Code. Please try again carefully.",
      titleClr: AppPalette.redClr,
    );
  } else if (state is BookingOTPMaching){
    context.read<BookingCancelBloc>().add(BookingCancelRequest(booking));
  } else if (state is BookingCancelLoading){
    buttonCubit.startLoading();
  } else if (state is BookingCancelWithoutRefundSuccess || state is BookingCancelSuccess ){
    buttonCubit.stopLoading();
    Navigator.pop(context);
      CustomeSnackBar.show(
      context: context,
      title: "Booking Cancelled Successfully" ,
      description: "Your appointment has been cancelled. We hope to serve you again soon. 💈",
      titleClr: AppPalette.greenClr,
    );
  } else if (state is BookingCancelFailure){
    buttonCubit.stopLoading();
       CustomeSnackBar.show(
      context: context,
      title: "Unable to Cancel Booking" ,
      description: "Unfortunately, we couldn't cancel your booking due to an error: ${state.errorMessage}. Please try again.",
      titleClr: AppPalette.blackClr,
    );
  }
}
