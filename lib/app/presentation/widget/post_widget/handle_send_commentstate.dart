
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/app/presentation/provider/bloc/send_comment_bloc/send_comment_bloc.dart';
import 'package:user_panel/auth/presentation/provider/cubit/button_progress_cubit/button_progress_cubit.dart';

import '../../../../core/common/custom_snackbar_widget.dart';
import '../../../../core/themes/colors.dart';

void handleSendComments(BuildContext context, SendCommentState state,
    TextEditingController controller) {
  final buttonCubit = context.read<ButtonProgressCubit>();
  if (state is SendCommentLoading) {
    buttonCubit.sendButtonStart();
  } else if (state is SendCommentSuccess) {
    controller.clear();
    buttonCubit.stopLoading();
  } else if (state is SendCommentFailure) {
    buttonCubit.stopLoading();

    CustomeSnackBar.show(
      context: context,
      title: 'Comment Not Delivered!  ',
      description:
          'We hit a bump while sending your Comment. Let’s try again. Error: ${state.error}',
      titleClr: AppPalette.redClr,
    );
  }
}