import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/auth/presentation/provider/bloc/register_bloc/register_bloc.dart';
import 'package:user_panel/auth/presentation/provider/cubit/button_progress_cubit/button_progress_cubit.dart';
import 'package:user_panel/core/themes/colors.dart';
import '../../../../core/routes/routes.dart';

void handleRegisterState(BuildContext context, RegisterState state, bool otpsed) {
  final buttonCubit = context.read<ButtonProgressCubit>();
  if (state is SubmitionConfirmationAlertState) {
    showCupertinoDialog(
    context: context,
    builder: (_) => CupertinoAlertDialog(
      title: Text('Registration Confirmation'),
      content: Text("Please verify your email to complete registration. A valid email address is required."),
      actions: [
        CupertinoDialogAction(
          child: Text("Don't Allow",style: TextStyle(color: AppPalette.blackClr)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () {
            Navigator.of(context).pop();
             context.read<RegisterBloc>().add((RegisterSubmit()));
          },
          child: Text('Allow',style: TextStyle(color: AppPalette.orengeClr),),
        ),
      ],
    ),
  );
  } else if (state is RegisterLoading) {
     buttonCubit.startLoading();
  } else if (state is RegisterSuccess) {
   buttonCubit.stopLoading();
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
  }else if(state is RegisterFailure) {
   buttonCubit.stopLoading();
     showCupertinoDialog(
    context: context,
    builder: (_) => CupertinoAlertDialog(
      title: Text('Login Failed'),
      content: Text(state.error),
      actions: [
        CupertinoDialogAction(
          child: Text('Retry',style: TextStyle(color: AppPalette.redClr)),
          onPressed: () {
            Navigator.of(context).pop();
             context.read<RegisterBloc>().add(RegisterSubmit());
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
