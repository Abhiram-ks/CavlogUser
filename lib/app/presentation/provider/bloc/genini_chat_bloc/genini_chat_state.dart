part of 'genini_chat_bloc.dart';


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