part of 'genini_chat_bloc.dart';

abstract class GeminiChatEvent {}

class SendGeminiMessage extends GeminiChatEvent {
  final String prompt;

  SendGeminiMessage(this.prompt);
}



class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}
