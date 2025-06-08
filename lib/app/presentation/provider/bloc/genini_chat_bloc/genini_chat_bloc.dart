import 'package:bloc/bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

part 'genini_chat_event.dart';
part 'genini_chat_state.dart';




class GeminiChatBloc extends Bloc<GeminiChatEvent, GeminiChatState> {
  final Gemini gemini;
  final List<ChatMessage> _chatHistory = [];

  GeminiChatBloc(this.gemini) : super(GeminiChatInitial()) {
    on<SendGeminiMessage>((event, emit) async {
      _chatHistory.add(ChatMessage(text: event.prompt, isUser: true));
      emit(GeminiChatLoading(messages: List.from(_chatHistory)));

      try {
        StringBuffer buffer = StringBuffer();

        await for (final content
            // ignore: deprecated_member_use
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

