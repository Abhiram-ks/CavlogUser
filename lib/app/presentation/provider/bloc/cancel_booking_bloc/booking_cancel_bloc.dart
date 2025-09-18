
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:user_panel/app/data/datasources/barber_wallet_remote_datasources.dart';
import 'package:user_panel/app/data/repositories/cancel_booking_repo.dart';
import 'package:user_panel/app/data/repositories/chenge_slot_status.dart';
import 'package:user_panel/app/data/repositories/refund_cancel_repo.dart';

import '../../../../../core/notification/local_notification_services.dart';
import '../../../../data/models/booking_model.dart';

part 'booking_cancel_event.dart';
part 'booking_cancel_state.dart';

class BookingCancelBloc extends Bloc<BookingCancelEvent, BookingCancelState> {
  final RefundCancelRepositoryDatasource refundRepo;
  final WalletTransactionRemoteDataSource transactionRemoteDataSource;
  final CancelBookingRepository cancelBookingRepository;
  final ChengeSlotStatusRepository chengeSlotStatusRepository;
  BookingCancelBloc(
      {required this.refundRepo,
      required this.transactionRemoteDataSource,
      required this.chengeSlotStatusRepository,
      required this.cancelBookingRepository})
      : super(BookingCancelInitial()) {
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
          final response = await cancelBookingRepository.updateBookingStatus(
              refund: refundAmount,
              docId: booking.bookingId ?? '',
              serviceStatus: 'Cancelled',
              transactionStatus: 'credited');

          if (response) {

            final bool result = await chengeSlotStatusRepository.chengeStatus(barberId: booking.barberId, docId: booking.slotDate, slotId: booking.slotId);

            if (!result) { 
              emit(BookingCancelFailure('Booking Cancel failure Status issue'));
              return;
            }
             await LocalNotificationServices.showNotification(
              title: 'Booking Cancelled Successfully',
              body:'Your appointment has been cancelled. We hope to serve you again soon. 💈',
              payload: 'booking_cancelled successfully',
            );  
            emit(BookingCancelWithoutRefundSuccess());
            return;
          } else {
            emit(BookingCancelFailure('Booking Cancel failure'));
            return;
          }
        }

        final barberSuccess = await refundRepo.barberWallet(
            barberId: booking.barberId, amount: refundAmount);

        if (!barberSuccess) {
          emit(BookingCancelFailure("Refund Canced to adminside rejection"));
          return;
        }

        final userSuccess = await refundRepo.userWallet(
            userId: booking.userId, amount: refundAmount);

        if (!userSuccess) {
          transactionRemoteDataSource.barberWalletUpdate(
              barberId: booking.barberId, amount: refundAmount);
          emit(BookingCancelFailure("Booking cancel failure wallet error"));
          return;
        }

        if (booking.bookingId != null) {
          final response = await cancelBookingRepository.updateBookingStatus(
              refund: refundAmount,
              docId: booking.bookingId ?? '',
              serviceStatus: 'Cancelled',
              transactionStatus: 'credited');
           final bool result = await chengeSlotStatusRepository.chengeStatus(barberId: booking.barberId, docId: booking.slotDate, slotId: booking.slotId);
          if (response && result) {
            await LocalNotificationServices.showNotification(
              title: 'Booking Cancelled Successfully',
              body:'Your appointment has been cancelled. We hope to serve you again soon. 💈',
              payload: 'booking_cancelled successfully',
            );
            emit(BookingCancelSuccess());
            return;
          } else {
            await cancelBookingRepository.updateBookingStatus(
              refund: 0.00,
              docId: booking.bookingId ?? '',
              serviceStatus: 'Pending',
              transactionStatus: 'debited');
            transactionRemoteDataSource.barberWalletUpdate( barberId: booking.barberId, amount: refundAmount);
            refundRepo.getUserWallet( userId: booking.userId, amount: refundAmount);
            emit(
                BookingCancelFailure('Booking cancel failure dut to db issue'));
            return;
          }
        } else {
          await cancelBookingRepository.updateBookingStatus(
              refund: 0.00,
              docId: booking.bookingId ?? '',
              serviceStatus: 'Pending',
              transactionStatus: 'debited');
          transactionRemoteDataSource.barberWalletUpdate(  barberId: booking.barberId, amount: refundAmount);
          refundRepo.getUserWallet( userId: booking.userId, amount: refundAmount);
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
