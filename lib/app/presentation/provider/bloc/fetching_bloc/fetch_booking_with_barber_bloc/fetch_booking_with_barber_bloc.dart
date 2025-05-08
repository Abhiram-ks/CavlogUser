import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:user_panel/app/data/models/booking_with_barber_model.dart';
import 'package:user_panel/app/data/repositories/fetch_booking_with_barber_model.dart';

import '../../../../../../auth/data/datasources/auth_local_datasource.dart';

part 'fetch_booking_with_barber_event.dart';
part 'fetch_booking_with_barber_state.dart';

class FetchBookingWithBarberBloc extends Bloc<FetchBookingWithBarberEvent, FetchBookingWithBarberState> {
  final FetchBookingAndBarberRepository _repository;

  FetchBookingWithBarberBloc(this._repository) : super(FetchBookingWithBarberInitial()) {
    on<FetchBookingWithBarberRequest>(_onFetchingBookingWithBarber);
    on<FetchBookingWithBarberFileterRequest>(_onFetchingBookingWithBarberFiltering);
  }

  Future<void> _onFetchingBookingWithBarber(
    FetchBookingWithBarberEvent event,
    Emitter<FetchBookingWithBarberState> emit,
  ) async {
    emit(FetchBookingWithBarberLoading());

    try {
      final credentials = await SecureStorageService.getUserCredentials();
      final String? userId = credentials['userId'];

      log('Fetched user ID from secure storage: $userId');

      if (userId == null || userId.isEmpty) {
        emit(FetchBookingWithBarberFailure('User ID not found. Please log in again.'));
        return;
      }

      await emit.forEach<List<BookingWithBarberModel>>(
        _repository.streamBookingsWithBarber(userId: userId),
        onData: (bookings) {
          if (bookings.isEmpty) {
            return FetchBookingWithBarberEmpty();
          } else {
            return FetchBookingWithBarberLoaded(combo: bookings);
          }
        },
        onError: (error, stackTrace) {
          log('Stream error: $error\n$stackTrace');
          return FetchBookingWithBarberFailure('Failed to fetch bookings. Please try again later.');
        },
      );
    } catch (e, st) {
      log('Exception during booking fetch: $e\n$st');
      emit(FetchBookingWithBarberFailure('An unexpected error occurred. Please try again later.'));
    }
  }

  Future<void> _onFetchingBookingWithBarberFiltering(
    FetchBookingWithBarberFileterRequest event,
    Emitter<FetchBookingWithBarberState> emit,
  )async {
    emit(FetchBookingWithBarberLoading());

    try {
       final credentials = await SecureStorageService.getUserCredentials();
    final String? userId = credentials['userId'];
    if (userId == null || userId.isEmpty) {
      emit(FetchBookingWithBarberFailure('User ID not found. Please log in again.'));
      return;
    }

    await emit.forEach<List<BookingWithBarberModel>>(
       _repository.streamBookingsWithBarber(userId: userId),
       onData: (bookings) {
        final filteredBooking = bookings.where((booking) => booking.booking.serviceStatus.toLowerCase().contains(event.filtering.toLowerCase())).toList();

        if (filteredBooking.isEmpty) {
          return FetchBookingWithBarberEmpty();
        }else {
          return FetchBookingWithBarberLoaded(combo: filteredBooking);
        }
       },
        onError: (error, stackTrace) {
        return FetchBookingWithBarberFailure('Filtering failed: $error');
      },
       );

    } catch (e) {
       emit(FetchBookingWithBarberFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}
