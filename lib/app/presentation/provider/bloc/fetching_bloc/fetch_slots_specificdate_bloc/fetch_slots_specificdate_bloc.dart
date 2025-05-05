import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../../../data/models/slot_model.dart';
import '../../../../../data/repositories/fetch_barber_slots_dates.dart';

part 'fetch_slots_specificdate_event.dart';
part 'fetch_slots_specificdate_state.dart';


class FetchSlotsSpecificdateBloc extends Bloc<FetchSlotsSpecificdateEvent, FetchSlotsSpecificDateState> {
  final FetchSlotsRepository _fetchSlotsRepository;
  
  FetchSlotsSpecificdateBloc(this._fetchSlotsRepository) : super(FetchSlotsSpecificDateInitial()) {
    on<FetchSlotsSpecificdateRequst>(_onFetchSlotsSpecificDateRequest);
  }

  Future<void> _onFetchSlotsSpecificDateRequest(
    FetchSlotsSpecificdateRequst event,
    Emitter<FetchSlotsSpecificDateState> emit,
  ) async {
    emit(FetchSlotsSpecificDateLoading());
    log('Fetching date in specific day : ${event.selectedDate}');
    try {

      await emit.forEach<List<SlotModel>>(
        _fetchSlotsRepository.streamSlots(
          barberUid: event.barberId,
          selectedDate: event.selectedDate,
        ),
        onData: (slots) {
          if (slots.isEmpty) {
            return FetchSlotsSpecificDateEmpty(event.selectedDate);
          } else {
            return FetchSlotsSpecificDateLoaded(slots: slots);
          }
        },
        onError: (error, stackTrace) {
          return FetchSlotsSpecificDateFailure(error.toString());
        },
      );

    } catch (e) {
      emit(FetchSlotsSpecificDateFailure(e.toString()));
    }
  }
}

