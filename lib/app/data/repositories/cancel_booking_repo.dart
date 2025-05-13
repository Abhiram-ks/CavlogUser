import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

abstract class CancelBookingRepository {
  Future<bool> updateBookingStatus({required String docId, required String serviceStatus,required String transactionStatus});
}


class CancelBookingRepositoryImpl implements CancelBookingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  @override
  Future<bool> updateBookingStatus({
    required String docId,
    required String serviceStatus,
    required String transactionStatus
  }) async {
    try {
      await _firestore.collection('bookings').doc(docId).update({
         'service_status': serviceStatus,
         'transaction': transactionStatus,
      });
      return true;
    } catch (e) {
      log('Error to updting service_status: $e');
      return false;
    }
  }
}