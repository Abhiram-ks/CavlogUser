

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../../../../auth/data/datasources/auth_local_datasource.dart';
import '../../../../../data/models/booking_model.dart';
import '../../../../../data/repositories/fetch_booking_transaction_repo.dart';

part 'fetch_booking_event.dart';
part 'fetch_booking_state.dart';

class FetchBookingBloc extends Bloc<FetchBookingEvent, FetchBookingState> {
  final FetchBookingTransactionRepository _bookingTransactionRepository;

  FetchBookingBloc(this._bookingTransactionRepository) : super(FetchBookingInitial()) {
    on<FetchBookingDatsRequest>(_onFetchBookingDatsRequest);
    on<FetchBookingDatasFilteringTransaction>(_onFilterBookingTransaction);

  }

  Future<void> _onFetchBookingDatsRequest(
    FetchBookingDatsRequest event,
    Emitter<FetchBookingState> emit,
  ) async {
    emit(FetchBookingLoading());
    try {
      final credentials = await SecureStorageService.getUserCredentials();
      final String? userId = credentials['userId'];

      if (userId == null || userId.isEmpty) {
        emit(FetchBookingFailure('User ID not found. Please log in again.'));
        return;
      }

      await emit.forEach<List<BookingModel>>(
        _bookingTransactionRepository.streamBookings(userId: userId),
        onData: (bookings) {
          if (bookings.isEmpty) {
            return FetchBookingEmpty();
          } else {
            return FetchBookingSuccess(bookings: bookings);
          }
        },
        onError: (error, stackTrace) {
          return FetchBookingFailure('Could not load booking data. Please try again later.');
        },
      );
    } catch (e) {
      emit(FetchBookingFailure('An unexpected error occurred. Please check your connection.'));
    }          
  }

Future<void> _onFilterBookingTransaction(
  FetchBookingDatasFilteringTransaction event,
  Emitter<FetchBookingState> emit,
) async {
  emit(FetchBookingLoading());
  try {
    final credentials = await SecureStorageService.getUserCredentials();
    final String? userId = credentials['userId'];
    if (userId == null || userId.isEmpty) {
      emit(FetchBookingFailure('User ID not found. Please log in again.'));
      return;
    }

    await emit.forEach<List<BookingModel>>(
      _bookingTransactionRepository.streamBookingsFilter(userId: userId,status: event.fillterText),
      onData: (datas) {
        if (datas.isEmpty) {
          return FetchBookingEmpty();
        } else {
          return FetchBookingSuccess(bookings: datas);
        }
      },
      onError: (error, stackTrace) {
        return FetchBookingFailure('Filtering failed: $error');
      },
    );
  } catch (e) {
    emit(FetchBookingFailure('An unexpected error occurred: ${e.toString()}'));
  }
}
}
