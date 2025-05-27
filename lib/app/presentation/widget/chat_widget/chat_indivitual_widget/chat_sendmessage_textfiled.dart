
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:user_panel/core/common/custom_snackbar_widget.dart';
import 'package:user_panel/core/themes/colors.dart';
import 'package:user_panel/core/utils/constant/constant.dart';

import '../../../../../auth/presentation/provider/cubit/button_progress_cubit/button_progress_cubit.dart';
import '../../../provider/bloc/image_picker/imge_picker_bloc.dart';

class ChatWindowTextFiled extends StatelessWidget {
  const ChatWindowTextFiled({
    super.key,
    required TextEditingController controller,
    required this.sendButton,
    this.icon,
    this.isICon = true
  }) : _controller = controller;

  final TextEditingController _controller;
  final VoidCallback sendButton;
  final bool isICon;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      color: AppPalette.whiteClr,
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Type a message",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  prefixIcon: isICon ? IconButton(
                    icon: const Icon(Icons.attach_file),
                    onPressed: () {
                      context.read<ImagePickerBloc>().add(PickImageAction());
                    },
                  ) : IconButton(onPressed: (){
                    CustomeSnackBar.show(context: context, title: "Relax. Your assistant is on it!", description: "My Assistant: Don’t worry — I’m right here if you need anything.", titleClr: AppPalette.blackClr);
                  }, icon: Icon(CupertinoIcons.cloud_upload_fill)),
                ),
                textInputAction: TextInputAction.send,
              ),
            ),
            ConstantWidgets.width20(context),
            GestureDetector(
              onTap: sendButton,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppPalette.buttonClr,
                  shape: BoxShape.circle,
                ),
                child: BlocBuilder<ButtonProgressCubit, ButtonProgressState>(
                  builder: (context, state) {
                    if (state is MessageSendLoading) {
                      return const SpinKitFadingCircle(
                        color: AppPalette.whiteClr,
                        size: 23.0,
                      );
                    }
                    return const Icon(
                      Icons.send,
                      color: AppPalette.whiteClr,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}