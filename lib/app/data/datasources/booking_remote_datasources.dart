import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking_model.dart' show BookingModel;
abstract class BookingRemoteDatasources {
  Future<bool> booking({required BookingModel booking});
}

class BookingRemoteDatasourcesImpl implements BookingRemoteDatasources {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<bool> booking({required BookingModel booking}) async {
    try {
      final docRef = firestore.collection('bookings');
      final doc = await docRef.add(booking.toMap());
      
      return doc.id.isNotEmpty;
    } catch (e, stacktrace) {
      log('Error creating booking: $e');
      log('Stacktrace: $stacktrace');
      return false;
    }
  }
}