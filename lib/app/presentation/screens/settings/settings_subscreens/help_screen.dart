import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_panel/app/data/repositories/image_picker_repo.dart';
import 'package:user_panel/app/domain/usecases/image_picker_usecase.dart';
import 'package:user_panel/app/presentation/provider/bloc/image_picker/imge_picker_bloc.dart';
import 'package:user_panel/app/presentation/widget/chat_widget/chat_indivitual_widget/chat_custombuble_widget.dart';
import 'package:user_panel/core/common/custom_appbar_widget.dart';
import 'package:user_panel/core/themes/colors.dart';
import '../../../../../core/utils/constant/constant.dart';
import '../../../widget/chat_widget/chat_indivitual_widget/chat_sendmessage_textfiled.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final TextEditingController _controller = TextEditingController();
  final bool isUser = true;
  final bool isGemini = false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => ImagePickerBloc(
                PickImageUseCase(ImagePickerRepositoryImpl(ImagePicker())))),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double screenHeight = constraints.maxHeight;
          final double screenWidth = constraints.maxWidth;
          return ColoredBox(
            color: AppPalette.hintClr,
            child: SafeArea(
              child: Scaffold(
                  appBar: CustomAppBar(),
                  body: DashChatWidget(
                    controller: _controller,
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                  ),
                  ),
            ),
          );
        },
      ),
    );
  }
}

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
        Expanded(
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
                          color:
                              AppPalette.buttonClr.withAlpha((0.3 * 255).round()),
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
        ),
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

String formatTimeOfDay(TimeOfDay time) {
  final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.period == DayPeriod.am ? 'AM' : 'PM';
  return '$hour:$minute $period';
}

abstract class GeminiChatEvent {}

class SendGeminiMessage extends GeminiChatEvent {
  final String prompt;

  SendGeminiMessage(this.prompt);
}


abstract class GeminiChatState {
  final List<ChatMessage> messages;

  GeminiChatState({this.messages = const []});
}

class GeminiChatInitial extends GeminiChatState {}

class GeminiChatLoading extends GeminiChatState {
  GeminiChatLoading({required super.messages});
}

class GeminiChatStreaming extends GeminiChatState {
  final String partial;
  GeminiChatStreaming({required this.partial, required super.messages});
}

class GeminiChatSuccess extends GeminiChatState {
  final String response;
  GeminiChatSuccess({required this.response, required super.messages});
}

class GeminiChatError extends GeminiChatState {
  final String message;
  GeminiChatError({required this.message, required super.messages});
}

class GeminiChatBloc extends Bloc<GeminiChatEvent, GeminiChatState> {
  final Gemini gemini;
  final List<ChatMessage> _chatHistory = [];

  GeminiChatBloc(this.gemini) : super(GeminiChatInitial()) {
    on<SendGeminiMessage>((event, emit) async {
      _chatHistory.add(ChatMessage(text: event.prompt, isUser: true));
      emit(GeminiChatLoading(messages: List.from(_chatHistory)));

      try {
        StringBuffer buffer = StringBuffer();

        // ignore: deprecated_member_use
        await for (final content
            in gemini.streamGenerateContent(event.prompt)) {
          if (content.output != null) {
            buffer.write(content.output);
            emit(GeminiChatStreaming(
              partial: buffer.toString(),
              messages: List.from(_chatHistory),
            ));
          }
        }

        _chatHistory.add(ChatMessage(text: buffer.toString(), isUser: false));
        emit(GeminiChatSuccess(
            response: buffer.toString(), messages: List.from(_chatHistory)));
      } catch (e) {
        emit(GeminiChatError(
            message: e.toString(), messages: List.from(_chatHistory)));
      }
    });
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}
