import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_panel/app/presentation/widget/chat_widget/chat_indivitual_widget/chat_sendmessage_textfiled.dart';
import 'package:user_panel/app/presentation/widget/settings_widget/help_widget/help_promit_chatbuilder.dart';
import '../../../../../core/utils/constant/constant.dart';
import '../../../provider/bloc/genini_chat_bloc/genini_chat_bloc.dart';

class DashChatWidget extends StatelessWidget {
  final TextEditingController controller;
  final double screenHeight;
  final double screenWidth;
  const DashChatWidget(
      {super.key,
      required this.controller,
      required this.screenHeight,
      required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Assistant',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ConstantWidgets.hight10(context),
              Text(
                'There are no limits to what you can accomplish, except the limits you place on your own thinking. Any problem can be solved with the right mindset and approach.',
              ),
              ConstantWidgets.hight20(context),
            ],
          ),
        ),
        HelpPromitChatBuilder(),
        ChatWindowTextFiled(
          controller: controller,
          isICon: false,
          sendButton: () {
            final text = controller.text.trim();
          
            if (text.isNotEmpty) {
              context.read<GeminiChatBloc>().add(SendGeminiMessage(text));
              controller.clear();
            }
          },
        )
      ],
    );
  }
}
