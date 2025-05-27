
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/app/domain/usecases/data_listing_usecase.dart';
import 'package:user_panel/app/presentation/provider/bloc/genini_chat_bloc/genini_chat_bloc.dart';
import 'package:user_panel/app/presentation/widget/chat_widget/chat_indivitual_widget/chat_custombuble_widget.dart';
import 'package:user_panel/core/themes/colors.dart';

import '../../../../../core/utils/constant/constant.dart';

class HelpPromitChatBuilder extends StatelessWidget {
  const HelpPromitChatBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<GeminiChatBloc, GeminiChatState>(
        builder: (context, state) {
          final messages = state.messages;
          if (state is GeminiChatInitial) {
            return SingleChildScrollView(
              reverse: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.smart_toy,size: 100,color: AppPalette.hintClr,),
                  Center(
                      child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4),
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppPalette.buttonClr.withAlpha((0.3 * 255).round()),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '⚿ Yes I am here to assist you with any questions or concerns you may have. Your chats are private and end-to-end encrypted.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppPalette.blackClr),
                    ),
                  )),
                  ConstantWidgets.hight50(context),
                ],
              ),
            );
          }
          return ListView.builder(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount:
                messages.length + (state is GeminiChatStreaming ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < messages.length) {
                final msg = messages[index];
                return MessageBubleWidget(
                  message: msg.text,
                  time: formatTimeOfDay(TimeOfDay.now()),
                  docId: msg.isUser ? 'user' : 'gemini',
                  isCurrentUser: msg.isUser,
                  delete: false,
                  softDelete: false,
                );
              } else if (state is GeminiChatStreaming) {
                return MessageBubleWidget(
                  message: state.partial,
                  time: formatTimeOfDay(TimeOfDay.now()),
                  docId: 'gemini_partial',
                  isCurrentUser: false,
                  delete: false,
                  softDelete: false,
                );
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstantWidgets.hight50(context),
                  Center(
                      child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4),
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppPalette.buttonClr
                          .withAlpha((0.3 * 255).round()),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '⚿ No conversations yet.Your chats are private and end-to-end encrypted. Only you and your barber can read them. Start a conversation now and enjoy seamless, secure messaging!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppPalette.blackClr),
                    ),
                  )),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
