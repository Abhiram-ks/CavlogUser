
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/core/themes/colors.dart';

import '../../../../../auth/presentation/provider/cubit/button_progress_cubit/button_progress_cubit.dart';
import '../../../../../core/common/custom_snackbar_widget.dart';
import '../../../provider/bloc/image_picker/imge_picker_bloc.dart';
import '../../../provider/bloc/send_message_bloc/send_message_bloc.dart';

void handleSendMessage(BuildContext context, SendMessageState state,TextEditingController controller) {
   final buttonCubit = context.read<ButtonProgressCubit>();
   if (state is SendMessageLoading) {
     buttonCubit.sendButtonStart();
   }
  else if(state is SendMessageSuccess) {
     controller.clear();
     context.read<ImagePickerBloc>().add(ClearImageAction());
     buttonCubit.stopLoading();
  } else if (state is SendMessageFailure) {
    buttonCubit.stopLoading();

    CustomeSnackBar.show(
      context: context,
      title: 'Message Not Delivered!  ',
      description: 'We hit a bump while sending your message. Let’s try again.',
      titleClr: AppPalette.redClr,
    );
  }
}