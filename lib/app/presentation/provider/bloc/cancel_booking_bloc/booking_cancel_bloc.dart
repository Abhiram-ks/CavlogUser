import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:user_panel/app/data/datasources/barber_wallet_remote_datasources.dart';
import 'package:user_panel/app/data/repositories/cancel_booking_repo.dart';
import 'package:user_panel/app/data/repositories/refund_cancel_repo.dart';

import '../../../../data/models/booking_model.dart';

part 'booking_cancel_event.dart';
part 'booking_cancel_state.dart';

class BookingCancelBloc extends Bloc<BookingCancelEvent, BookingCancelState> {
  final RefundCancelRepositoryDatasource refundRepo;
  final WalletTransactionRemoteDataSource transactionRemoteDataSource;
  final CancelBookingRepository cancelBookingRepository;
  BookingCancelBloc({required this.refundRepo, required this.transactionRemoteDataSource, required this.cancelBookingRepository}) : super(BookingCancelInitial()) {

    on<BookingOTPChecking>((event, emit) {
     if (event.inputOTP == event.bookingOTP) {
        emit(BookingOTPMaching());
      } else {
        emit(BookingOPTNotMaching());
      }
    });

    
    on<BookingCancelRequest>((event, emit) async {
       emit(BookingCancelLoading());
      try {
        final BookingModel booking = event.model;

        final startTime = booking.slotTime.isNotEmpty
          ? (List<DateTime>.from(booking.slotTime)..sort()).first
          : null;

        if (startTime == null) {
         emit(BookingCancelFailure("Invalid booking slot time."));
         return;
        }

        final now = DateTime.now();
        final diff = startTime.difference(now);
         double refundAmount = 0.0;
        if (diff.inMinutes >= 30) {
         refundAmount = booking.amountPaid - (booking.amountPaid * 0.01);
        }

        if (refundAmount == 0) {
          final response = await cancelBookingRepository.updateBookingStatus(docId: booking.bookingId ?? '', serviceStatus: 'Cancelled', transactionStatus: 'credited');

          if (response) {
           emit(BookingCancelWithoutRefundSuccess());
           return;
          } else {
            emit(BookingCancelFailure('Booking Cancel failure'));
            return;
          }
        }
        

        final barberSuccess = await refundRepo.barberWallet(barberId: booking.barberId, amount: refundAmount);

        if (!barberSuccess) {
          emit(BookingCancelFailure("Refund Canced to adminside rejection"));
          return;
        }

        final userSuccess = await refundRepo.userWallet(userId: booking.userId, amount: refundAmount);

        if (!userSuccess) {
          transactionRemoteDataSource.barberWalletUpdate(barberId: booking.barberId, amount: refundAmount);
          emit(BookingCancelFailure("Booking cancel failure wallet error"));
          return;
        }
        
        if (booking.bookingId != null) {
           final response = await cancelBookingRepository.updateBookingStatus(docId: booking.bookingId ?? '', serviceStatus: 'Cancelled', transactionStatus: 'credited');

           if (response) {
             emit(BookingCancelSuccess());
             return;
           } else {
              transactionRemoteDataSource.barberWalletUpdate(barberId: booking.barberId, amount: refundAmount);
              refundRepo.getUserWallet(userId: booking.userId, amount: refundAmount);
              emit(BookingCancelFailure('Booking cancel failure dut to db issue'));
              return;
           }
        }else {
           transactionRemoteDataSource.barberWalletUpdate(barberId: booking.barberId, amount: refundAmount);
           refundRepo.getUserWallet(userId: booking.userId, amount: refundAmount);
           emit(BookingCancelFailure('Booking cancel failure dut to db issue'));
           return;
        }
       
        
      } catch (e) {
        emit(BookingCancelFailure('Booking cancel failure due to $e'));
        return;
      }
    });

  }
}
