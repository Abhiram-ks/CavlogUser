
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/app/data/models/booking_model.dart';

import '../../../../../auth/presentation/provider/cubit/button_progress_cubit/button_progress_cubit.dart';
import '../../../provider/bloc/cancel_booking_bloc/booking_cancel_bloc.dart';

void handleCancelBookingState( BuildContext context, BookingCancelState state, BookingModel booking){
  final buttonCubit = context.read<ButtonProgressCubit>();

  if (state is BookingOPTNotMaching) {
    
  }
}
