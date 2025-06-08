import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/auth/presentation/provider/bloc/reset_password/reset_password_bloc.dart';
import 'package:user_panel/auth/presentation/provider/cubit/button_progress_cubit/button_progress_cubit.dart';
import 'package:user_panel/core/common/custom_snackbar_widget.dart';

import '../../../../core/themes/colors.dart';

void handResetPasswordState(BuildContext context, ResetPasswordState state,TextEditingController emailController){
  final butttonCubit = context.read<ButtonProgressCubit>();
  if (state is ResetPasswordLoading) {
     butttonCubit.startLoading();
  } else if (state is ResetPasswordSuccess) {
    butttonCubit.stopLoading();
    emailController.clear(); 
    CustomeSnackBar.show(
    context: context,
    title: "Success",
    description: "Done! Open your inbox and follow the instructions to reset your password.",
    titleClr: AppPalette.greenClr,
    );
  } else if (state is ResetPasswordFailure){
    butttonCubit.stopLoading();
     showCupertinoDialog(
    context: context,
    builder: (_) => CupertinoAlertDialog(
      title: Text('Forgot password?'),
      content: Text('Something went wrong. Please try again.'),
      actions: [
        CupertinoDialogAction(
          child: Text('Retry',style: TextStyle(color: AppPalette.redClr)),
          onPressed: () {
            Navigator.of(context).pop();
            context.read<ResetPasswordBloc>().add(ResetPasswordRequestEvent(email: emailController.text.trim()));
          },
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel',style: TextStyle(color: AppPalette.blackClr),),
        ),
      ],
    ),
  );
  }
}