
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/app/presentation/provider/bloc/delete_account_bloc/delete_account_bloc.dart';
import 'package:user_panel/auth/presentation/screen/login_screen/login_screen.dart';
import 'package:user_panel/core/themes/colors.dart';

import '../../../../../auth/presentation/provider/cubit/button_progress_cubit/button_progress_cubit.dart';

void handleDeleteAccountState (BuildContext context, DeleteAccountState state){
  final buttonProgress = context.read<ButtonProgressCubit>();

  if(state is DeleteAccountLoadingState){
    buttonProgress.startLoading();
  }else if(state is DeleteAccountSuccessState){
    buttonProgress.stopLoading();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (route) => false);
  }else if(state is DeleteAccountFailureState){
    buttonProgress.stopLoading();
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text('Deletion Failed'),
        content: Text("Unfortunately, an unexpected error occurred. Please try again later. If the issue persists, your account may be automatically removed from the system after a short period. Thank you for your patience."),
        actions: [
          CupertinoDialogAction(
            child: Text('Retry', style: TextStyle(color: AppPalette.redClr)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: AppPalette.blackClr),
            ),
          ),
        ],
      ),
    );
  }
}