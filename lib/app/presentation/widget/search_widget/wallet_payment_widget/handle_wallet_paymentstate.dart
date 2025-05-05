
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../auth/presentation/provider/cubit/button_progress_cubit/button_progress_cubit.dart';
import '../../../../../core/common/custom_snackbar_widget.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../core/themes/colors.dart';
import '../../../provider/bloc/wallet_payment_bloc/wallet_payment_bloc.dart';
import '../../../screens/pages/search/payment_screen/payment_success_screen.dart';

void handleWalletPaymentStates({required BuildContext context,required WalletPaymentState state,required String totalAmount,required  String barberUid,required List<Map<String, dynamic>> selectedServices}) {
    final buttonCubit = context.read<ButtonProgressCubit>();
  if(state is WalletPaymentLoading){
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
    buttonCubit.startLoading();
     CustomeSnackBar.show(
      context: context,
      title: 'Digital Transaction Failed!',
      description: 'Oops! An error occurred. ${state.errorMessage}. Transaction failed. Please try again later!',
      titleClr: AppPalette.redClr,
    );
  }
}
