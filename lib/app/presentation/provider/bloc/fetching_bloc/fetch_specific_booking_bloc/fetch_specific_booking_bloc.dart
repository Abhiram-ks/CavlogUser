import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:user_panel/app/data/models/booking_model.dart';
import 'package:user_panel/app/data/repositories/fetch_specific_booking_repo.dart';

part 'fetch_specific_booking_event.dart';
part 'fetch_specific_booking_state.dart';

class FetchSpecificBookingBloc extends Bloc<FetchSpecificBookingEvent, FetchSpecificBookingState> {
  final FetchSpecificBookingRepository _repository;

  FetchSpecificBookingBloc(this._repository) : super(FetchSpecificBookingInitial()) {
    on<FetchSpecificBookingRequest>(_onFetchBooking);
  }

  Future<void> _onFetchBooking(
    FetchSpecificBookingRequest event,
    Emitter<FetchSpecificBookingState> emit,
  ) async {
    emit(FetchSpecificBookingLoading());

    await emit.forEach<BookingModel>(
      _repository.streamBooking(docId: event.docId),
      onData: (booking) => FetchSpecificBookingLoaded(booking: booking),
      onError: (error, _) => FetchSpecificBookingFailure("Error fetching booking: $error"),
    );
  }
}
