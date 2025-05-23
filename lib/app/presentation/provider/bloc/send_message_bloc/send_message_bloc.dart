import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../core/cloudinary/cloudinary_service.dart';
import '../../../../data/datasources/chat_remote_datasources.dart';
import '../../../../data/models/chat_model.dart';
part 'send_message_event.dart';
part 'send_message_state.dart';

class SendMessageBloc extends Bloc<SendMessageEvent, SendMessageState> {
  final ChatRemoteDatasources chatRemoteDatasources;
  final CloudinaryService cloudinaryService;

  SendMessageBloc({
    required this.chatRemoteDatasources,
    required this.cloudinaryService,
  }) : super(SendMessageInitial()) {
    on<SendTextMessage>(_onSendTextMessage);
    on<SendImageMessage>(_onSendImageMessage);
  }

  Future<void> _onSendTextMessage(
    SendTextMessage event,
    Emitter<SendMessageState> emit,
  ) async {
    emit(SendMessageLoading());

    final now = DateTime.now();
    final message = ChatModel(
      senderId: event.userId,
      barberId: event.barberId,
      userId: event.userId,
      message: event.message,
      createdAt: now,
      updateAt: now,
      isSee: false,
      delete: false,
      softDelete: false,
    );

    final success = await chatRemoteDatasources.sendMessage(message: message);
    emit(success ? SendMessageSuccess() : SendMessageFailure());
  }

  Future<void> _onSendImageMessage(
    SendImageMessage event,
    Emitter<SendMessageState> emit,
  ) async {
    emit(SendMessageLoading());

    try {
      final uploadedImageUrl = await cloudinaryService.uploadImage(File(event.image));

      if (uploadedImageUrl == null) {
        emit(SendMessageFailure());
        return;
      }
      

      final now = DateTime.now();
      final message = ChatModel(
        senderId: event.userId,
        barberId: event.barberId,
        userId: event.userId,
        message: uploadedImageUrl,
        createdAt: now,
        updateAt: now,
        isSee: false,
        delete: false,
        softDelete: false,
      );

      final success = await chatRemoteDatasources.sendMessage(message: message);
      emit(success ? SendMessageSuccess() : SendMessageFailure());
    } catch (_) {
      emit(SendMessageFailure());
    }
  }
}
