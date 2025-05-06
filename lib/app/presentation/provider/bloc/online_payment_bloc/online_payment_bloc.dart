import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:user_panel/app/data/datasources/booking_remote_datasources.dart';
import '../../../../../auth/data/datasources/auth_local_datasource.dart';
import '../../../../data/datasources/barber_wallet_remote_datasources.dart';
import '../../../../data/models/booking_model.dart';
import '../../../../data/models/slot_model.dart';
import '../../../../data/repositories/slot_cheking_repo.dart';
import '../../../../domain/usecases/data_listing_usecase.dart';
import '../../../../domain/usecases/generate_booking_otp.dart';
part 'online_payment_event.dart';
part 'online_payment_state.dart';

class OnlinePaymentBloc extends Bloc<OnlinePaymentEvent, OnlinePaymentState> {
  final BookingRemoteDatasources bookingRemoteDatasources;
  final WalletTransactionRemoteDataSource walletTransactionRemoteDataSource;
  final SlotChekingRepository slotCheckingRepository;

  OnlinePaymentBloc({required this.bookingRemoteDatasources, required this.slotCheckingRepository, required this.walletTransactionRemoteDataSource}) : super(OnlinePaymentInitial()) {
      on<OnlinePaymentRequest>(_handleOnlinePaymentRequest);
      on<OnlinePaymentCheckSlots>(_handleSlotChekings);
  }

  Future<void> _handleSlotChekings(OnlinePaymentCheckSlots event, Emitter<OnlinePaymentState> emit) async {
     try {
      final available = await slotCheckingRepository.slotCheking(
        barberId: event.barberId,
        selectedSlots: event.selectedSlots,
      );
      if (!available) {
        emit(OnlinePaymentSlogNotAvalable());
        return;
      }

      emit(OnlinePaymntSlotAvalable());
     } catch (e) {
       emit(OnlinePaymentFailure("Slot booking must be atomic to prevent double booking."));
     }
  
  }

  Future<void> _handleOnlinePaymentRequest( OnlinePaymentRequest event,
    Emitter<OnlinePaymentState> emit) async {
      emit(OnlinePaymentLoading());

    try {
        final credentials = await SecureStorageService.getUserCredentials();
        final String? userId = credentials['userId'];

      if (userId == null) {
        emit(OnlinePaymentFailure('User ID not found. Please login again.'));
        return;
      }
      
            // 1. Slot Availability Check
      final available = await slotCheckingRepository.slotCheking(
        barberId: event.barberId,
        selectedSlots: event.selectedSlots,
      );
      if (!available) {
        emit(OnlinePaymentSlogNotAvalable());
        return;
      }

      final booking = await prepareBookingModelOnline(userId: userId, event: event);
 
      final double barberAmount = event.bookingAmount - event.platformFee;
      final bool barberWalletUpdated = await walletTransactionRemoteDataSource.barberWalletUpdate(barberId: event.barberId, amount: barberAmount);
      final bool adminWalletUpdated = await walletTransactionRemoteDataSource.platformFreeUpdate(platformFee: event.platformFee);

      if (!(barberWalletUpdated && adminWalletUpdated)){
       emit(OnlinePaymentFailure('Wallet payment Transaction failed. Please try again.'));
       return;
      }
    

       // 4. Slot Booking
      final slotBooked = await slotCheckingRepository.slotBooking(
        barberId: event.barberId,
        selectedSlots: event.selectedSlots,
      );
       
      log('slot values updation working well done : $slotBooked');
      if (!slotBooked) {
        emit(OnlinePaymentFailure('Slot booking failed. Amount will be refunded in 1–3 business days.'));
        return;
      }

      // 5. Booking Creation
      final bookingCreated = await bookingRemoteDatasources.booking(booking: booking);

      if (bookingCreated) {
        emit(OnlinePaymentSuccess());
      } else {
        emit(OnlinePaymentFailure(  'Booking creation failed. Contact support if amount was deducted.'));
      }

    } catch (e) {
      emit(OnlinePaymentFailure('Unexpected error: ${e.toString()}'));
    }
  }
}



Future<BookingModel> prepareBookingModelOnline({
  required String userId,
  required OnlinePaymentRequest event,
}) async {
  final String bookingOTP = GenerateBookingOtp().generateOtp();

  final Map<String, double> serviceTypeMap = {
    for (var item in event.selectedServices)
      item['serviceName']: (item['serviceAmount'] as num).toDouble(),
  };

  final List<DateTime> slotTimes = event.selectedSlots.map((slot) => slot.startTime).toList();

  final int totalDuration = event.selectedSlots
      .fold(0, (sum, slot) => sum + slot.duration.inMinutes);

  return BookingModel(
    userId: userId,
    barberId: event.barberId,
    duration: totalDuration,
    paymentMethod: "Online Banking",
    createdAt: DateTime.now(),
    serviceType: serviceTypeMap,
    slotTime: slotTimes,
    amountPaid: event.bookingAmount,
    status: "Completed",
    otp: bookingOTP,
    transaction: 'debited',
    serviceStatus: 'Pending'
  );
}
