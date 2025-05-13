
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../auth/presentation/provider/cubit/button_progress_cubit/button_progress_cubit.dart';
import '../../../../../core/common/custom_snackbar_widget.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../core/stripe/stripe_payment_sheet.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../data/models/slot_model.dart';
import '../../../provider/bloc/wallet_payment_bloc/wallet_payment_bloc.dart';
import '../../../screens/pages/search/payment_screen/payment_success_screen.dart';

void handleWalletPaymentStates({required BuildContext context,required WalletPaymentState state,required String totalAmount,required  String barberUid,required List<Map<String, dynamic>> selectedServices, required double balance, required double isShortfallAmount, required double
 bookingAmount, required double platformFee, required List<SlotModel> selectedSlots}) async{
    final buttonCubit = context.read<ButtonProgressCubit>();
  if (state is WalletPaymntSlotAvalable ){
       if (balance >= 100) {
          if (isShortfallAmount == 0.0) {
             context.read<WalletPaymentBloc>().add(WalletPaymentRequest(
             invoiceId: '',
             bookingAmount:bookingAmount,
             barberId: barberUid,
             selectedServices: selectedServices,
             selectedSlots:selectedSlots,
             platformFee: platformFee));
            } else {
             final String? success =  await StripePaymentSheetHandler.instance.presentPaymentSheet(context: context, amount: isShortfallAmount, currency: 'usd',label:  'Pay   $isShortfallAmount');
             if (!context.mounted) return;
                if (success != null) {
                  context.read<WalletPaymentBloc>().add(WalletPaymentRequest(
                  invoiceId: success,
                  bookingAmount:bookingAmount,
                  barberId: barberUid,
                  selectedServices: selectedServices,
                  selectedSlots:selectedSlots,
                  platformFee: platformFee
                  ));
                }  else {
                 CustomeSnackBar.show(
                  context: context,title: "Payment processing failed.",
                  description: "Oops! There was an issue with your slot booking or payment method. Please try again.",
                  titleClr: AppPalette.redClr);
                 return;
                }
            }
          } else {
            CustomeSnackBar.show(
              context: context,
              title: "Insufficient Balance",
              description: 'To use Digital Money Pay, your wallet balance must be at least ₹100. Please top up your wallet to proceed.',
              titleClr: AppPalette.blackClr);
          }
  }
  else if(state is WalletPaymentLoading){
    buttonCubit.startLoading();
  }else if (state is WalletPaymentSuccess) {
    buttonCubit.stopLoading();
      Navigator.of(context).push(
        MaterialPageRoute(
           builder: (context) =>PaymentSuccessScreen(totalAmount: totalAmount, barberUid: barberUid, selectedServices: selectedServices,isWallet: true),
        ),
      );
  } else if(state is WalletPaymentSlotNotAvalbale){
    buttonCubit.stopLoading();
     Navigator.popUntil( context,(route) => route.settings.name == AppRoutes.booking);
  }
  else if(state is WalletPaymentFailure){
    buttonCubit.stopLoading();
     CustomeSnackBar.show(
      context: context,
      title: 'Digital Transaction Failed!',
      description: 'Oops! An error occurred. ${state.errorMessage}. Transaction failed. Please try again later!',
      titleClr: AppPalette.redClr,
    );
  }
}
