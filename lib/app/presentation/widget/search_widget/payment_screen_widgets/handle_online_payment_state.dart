import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/app/presentation/provider/bloc/online_payment_bloc/online_payment_bloc.dart';
import 'package:user_panel/app/presentation/widget/search_widget/payment_screen_widgets/payment_payment_option_widget.dart';

import '../../../../../auth/presentation/provider/cubit/button_progress_cubit/button_progress_cubit.dart';
import '../../../../../core/common/custom_snackbar_widget.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../core/stripe/stripe_payment_sheet.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../data/models/slot_model.dart';
import '../../../provider/cubit/booking_cubits/corrency_convertion_cubit/corrency_conversion_cubit.dart';
import '../../../provider/cubit/booking_cubits/date_selection_cubit/date_selection_cubit.dart';
import '../../../screens/pages/search/payment_screen/payment_success_screen.dart';
import '../../../screens/pages/search/wallet_payment_screen/wallet_paymet_screen.dart';

void handleOnlinePaymentStates({required BuildContext context,required OnlinePaymentState state,required String totalAmount,required  String barberUid,required List<Map<String, dynamic>> selectedServices, required CurrencyConversionState convertionState, required double screenWidth, required double screenHeight, required List<SlotModel> selectedSlots, required double platformFee, required double  totalInINR, required  SlotSelectionCubit slotSelectionCubit, required String labelText}) {
    final buttonCubit = context.read<ButtonProgressCubit>();


  if (state is OnlinePaymntSlotAvalable) {
    log('howw does it working $state');
     BottomSheetPaymentOption().showBottomSheet(
      context: context, screenHeight: screenHeight,screenWidth: screenWidth,
      walletPaymentAction: () {
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(
             builder: (context) => WalletPaymetScreen(
              selectedSlots: selectedSlots,barberUid: barberUid,
              platformFee: platformFee,
              totalAmount: totalInINR,
              selectedServices: selectedServices,
              slotSelectionCubit: slotSelectionCubit,
             ),
            ),
          );
        },
      stripePaymentAction: () async {
        Navigator.pop(context);
        double usdAmount;
          if (convertionState  is CurrencyConversionSuccess) {
            usdAmount = convertionState.convertedAmount;
          } else {
            CustomeSnackBar.show(
              context: context,title: "Payment processing failed.", description: "Oops! There was an issue with your slot booking or payment method. Please try again.",titleClr: AppPalette.redClr);
              return;
          }
          final bool success =  await StripePaymentSheetHandler.instance .presentPaymentSheet( context: context, amount: usdAmount, currency: 'usd',label: 'Pay $labelText');
          if (!context.mounted) return;
          if (success) {
          context.read<OnlinePaymentBloc>().add(OnlinePaymentRequest(
            bookingAmount:totalInINR,barberId: barberUid,
            selectedServices: selectedServices,selectedSlots:selectedSlots,
            platformFee: platformFee
          ));
          } else {
            CustomeSnackBar.show( context: context,title: "Payment processing failed.", description: "Oops! There was an issue with your slot booking or payment method. Please try again.",titleClr: AppPalette.redClr);
            return;
           }
        });
  }else if (state is OnlinePaymentLoading){
    buttonCubit.startLoading();
  }else if (state is OnlinePaymentSuccess) {
    buttonCubit.stopLoading();
      Navigator.of(context).push(
        MaterialPageRoute(
           builder: (context) =>PaymentSuccessScreen(totalAmount: totalAmount, barberUid: barberUid, selectedServices: selectedServices,isWallet: false),
        ),
      );
  } else if(state is OnlinePaymentSlogNotAvalable){
    buttonCubit.stopLoading();
     Navigator.popUntil( context,(route) => route.settings.name == AppRoutes.booking);
  }
  else if(state is OnlinePaymentFailure){
    buttonCubit.stopLoading();
     CustomeSnackBar.show(
      context: context,
      title: 'Online Transaction Failed!',
      description: 'Oops! An error occurred. ${state.errorMessage}. Transaction failed. Please try again later!',
      titleClr: AppPalette.redClr,
    );
  }
}
