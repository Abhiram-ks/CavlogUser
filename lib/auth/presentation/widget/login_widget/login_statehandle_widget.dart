import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/themes/colors.dart';
import '../../provider/bloc/login_bloc/login_bloc.dart';
import '../../provider/cubit/button_progress_cubit/button_progress_cubit.dart';

void handleLoginState(BuildContext context, LoginState state,TextEditingController emailController, TextEditingController passwordController){
   final buttonCubit = context.read<ButtonProgressCubit>();
   if (state is LoginLoading) {
     buttonCubit.startLoading();
   }
  else if(state is LoginSuccess) {
     Navigator.pushReplacementNamed(context, AppRoutes.home);
     buttonCubit.stopLoading();
  } else if (state is LoginFiled) {
    buttonCubit.stopLoading();
    String errorMessage = 'Something went wrong. Please try again.';

    if (state.error.contains("Incorrect Email or Password")) {
      errorMessage = 'Incorrect Email or Password';
    } else if (state.error.contains("Too many requests")) {
      errorMessage = 'Too many requests. please retry after some time.';
    } else if (state.error.contains("Network Error")) {
      errorMessage = 'Network Connection failed';
    }
    
      showCupertinoDialog(
    context: context,
    builder: (_) => CupertinoAlertDialog(
      title: Text('Login Failed'),
      content: Text(errorMessage),
      actions: [
        CupertinoDialogAction(
          child: Text('Retry',style: TextStyle(color: AppPalette.redClr)),
          onPressed: () {
            Navigator.of(context).pop();
            context.read<LoginBloc>().add(LoginActionEvent(context, email:  emailController.text.trim(), password: passwordController.text.trim()));
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