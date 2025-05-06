import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:user_panel/app/data/datasources/barber_wallet_remote_datasources.dart';
import 'package:user_panel/app/data/datasources/booking_remote_datasources.dart';
import 'package:user_panel/app/data/models/booking_model.dart';
import 'package:user_panel/app/data/repositories/slot_cheking_repo.dart';
import 'package:user_panel/app/domain/usecases/generate_booking_otp.dart';

import '../../../../../auth/data/datasources/auth_local_datasource.dart';
import '../../../../data/models/slot_model.dart';
import '../../../../data/repositories/wallet_payment_repo.dart';
import '../../../../domain/usecases/data_listing_usecase.dart';

part 'wallet_payment_event.dart';
part 'wallet_payment_state.dart';


class WalletPaymentBloc extends Bloc<WalletPaymentEvent, WalletPaymentState> {
  final WalletPaymentRepository repository;
  final BookingRemoteDatasources bookingRemoteDatasources;
  final WalletTransactionRemoteDataSource walletTransactionRemoteDataSource;
  final SlotChekingRepository slotCheckingRepository;

  WalletPaymentBloc({
   required this.repository,
   required this.bookingRemoteDatasources,
   required this.slotCheckingRepository,
   required this.walletTransactionRemoteDataSource,
  }) : super(WalletPaymentInitial()) {
    on<WalletPaymentRequest>(_handleWalletPaymentRequest);
    on<WalletPaymentCheckSlots>(_handleSlotChekings);
  }

    Future<void> _handleSlotChekings(WalletPaymentCheckSlots event, Emitter<WalletPaymentState> emit) async {
     try {
      final available = await slotCheckingRepository.slotCheking(
        barberId: event.barberId,
        selectedSlots: event.selectedSlots,
      );
      if (!available) {
        emit(WalletPaymentSlotNotAvalbale());
        return;
      }

      emit(WalletPaymntSlotAvalable());
     } catch (e) {
       emit(WalletPaymentFailure("Slot booking must be atomic to prevent double booking."));
     }
  
  }

  Future<void> _handleWalletPaymentRequest(
    WalletPaymentRequest event,
    Emitter<WalletPaymentState> emit,
  ) async {
    emit(WalletPaymentLoading());

    try {
      final credentials = await SecureStorageService.getUserCredentials();
      final String? userId = credentials['userId'];

      if (userId == null) {
        emit(WalletPaymentFailure('User ID not found. Please login again.'));
        return;
      }

      // 1. Slot Availability Check
      final available = await slotCheckingRepository.slotCheking( 
        barberId: event.barberId,
        selectedSlots: event.selectedSlots,
      );
      if (!available) {
        emit(WalletPaymentSlotNotAvalbale());
        return;
      }
      
      final booking = await prepareBookingModel(userId: userId, event: event);
      // 3. Wallet Deduction
      final walletSuccess = await repository.walletPayment(
        userId: userId,
        bookingAmount: event.bookingAmount,
      );
      if (!walletSuccess) {
        emit(WalletPaymentFailure('Wallet payment failed. Please try again.'));
        return;
      }
      
      final double barberAmount = event.bookingAmount - event.platformFee;
      final bool barberWalletUpdated = await walletTransactionRemoteDataSource.barberWalletUpdate(barberId: event.barberId, amount: barberAmount);
      final bool adminWalletUpdated = await walletTransactionRemoteDataSource.platformFreeUpdate(platformFee: event.platformFee);

      if (!(barberWalletUpdated && adminWalletUpdated)){
       emit(WalletPaymentFailure('Wallet payment Transaction failed. Please try again.'));
       return;
      }
      // 4. Slot Booking
      final slotBooked = await slotCheckingRepository.slotBooking(
        barberId: event.barberId,
        selectedSlots: event.selectedSlots,
      );
    
      if (!slotBooked) {
        emit(WalletPaymentFailure('Slot booking failed. Amount will be refunded in 1–3 business days.'));
        return;
      }

      // 5. Booking Creation
      final bookingCreated = await bookingRemoteDatasources.booking(booking: booking);

      if (bookingCreated) {
        emit(WalletPaymentSuccess());
      } else {
        emit(WalletPaymentFailure('Booking creation failed. Contact support if amount was deducted.'));
      }
    } catch (e) {
      emit(WalletPaymentFailure('Unexpected error: ${e.toString()}'));
    }
  }
}



Future<BookingModel> prepareBookingModel({
  required String userId,
  required WalletPaymentRequest event,
}) async {
  final String bookingOTP = GenerateBookingOtp().generateOtp();

  final Map<String, double> serviceTypeMap = {
    for (var item in event.selectedServices)
      item['serviceName']: (item['serviceAmount'] as num).toDouble(),
  };

  final List<DateTime> slotTimes = event.selectedSlots.map((slot) => slot.startTime).toList();

  final int totalDuration = event.selectedSlots.fold(0, (sum, slot) => sum + slot.duration.inMinutes);

  return BookingModel(
    userId: userId,
    barberId: event.barberId,
    duration: totalDuration,
    paymentMethod: "Digital money / Wallet",
    createdAt: DateTime.now(),
    serviceType: serviceTypeMap,
    slotTime: slotTimes,
    amountPaid: event.bookingAmount,
    status: "Completed",
    otp: bookingOTP,
    transaction: 'debited',
    serviceStatus: 'Pending',
  );
}
