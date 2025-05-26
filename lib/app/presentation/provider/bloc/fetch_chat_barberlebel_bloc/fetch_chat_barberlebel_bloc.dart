import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:user_panel/app/data/models/barber_model.dart';
import 'package:user_panel/app/data/repositories/fetch_message_repo.dart';

import '../../../../../auth/data/datasources/auth_local_datasource.dart';

part 'fetch_chat_barberlebel_event.dart';
part 'fetch_chat_barberlebel_state.dart';

class FetchChatBarberlebelBloc extends Bloc<FetchChatBarberlebelEvent, FetchChatBarberlebelState> {
  final FetchMessageAndBarberRepo _repository;
  FetchChatBarberlebelBloc(this._repository) : super(FetchChatBarberlebelInitial()) {
    on<FetchChatLebelBarberRequst>(_onFetchchatwithBarberRequst);
    on<FetchChatLebelBarberSearch>(_onFetchchatwithBarberSerch);
  }

  Future<void> _onFetchchatwithBarberRequst(
    FetchChatLebelBarberRequst event,
    Emitter<FetchChatBarberlebelState> emit,   
  ) async {  
    emit(FetchChatBarberlebelLoading());
    try {
     final credentials = await SecureStorageService.getUserCredentials();
      final String? userId = credentials['userId'];
      
      if (userId == null || userId.isEmpty) {
        emit(FetchChatBarberlebelFailure());
        return;
      }
      
      await emit.forEach<List<BarberModel>>(
        _repository.streamChat(userid: userId), 
        onData: (chat) {
          if (chat.isEmpty) {
            return FetchChatBarberlebelEmpty();
          } else {
            return FetchChatBarberlebelSuccess(chat);
          }
        },
           onError: (error, stackTrace) {
          log('Stream error: $error\n$stackTrace');
          return FetchChatBarberlebelFailure();
        },
        );
    } catch (e) {
      emit(FetchChatBarberlebelFailure());
    }
  }

  void _onFetchchatwithBarberSerch(
    FetchChatLebelBarberSearch event,
    Emitter<FetchChatBarberlebelState> emit,
  )async{
    emit(FetchChatBarberlebelLoading());
     final credentials = await SecureStorageService.getUserCredentials();
     final String? userId = credentials['userId'];
      
      if (userId == null || userId.isEmpty) {
        emit(FetchChatBarberlebelFailure());
        return;
      }
    await emit.forEach<List<BarberModel>>(
      _repository.streamChat(userid: userId),
      onData: (barbers){
        final filteredBarbers = barbers.where((barber) => barber.ventureName.toLowerCase().contains(event.searchController.toLowerCase())).toList();

        if (filteredBarbers.isEmpty) {
           return FetchChatBarberlebelEmpty();
        }else {
           return FetchChatBarberlebelSuccess(filteredBarbers);
        }
      },
       onError: (error, stackTrace) {
        return FetchChatBarberlebelFailure();
      },
    );

  }

}
