import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_panel/app/data/models/barber_model.dart';
import 'package:user_panel/app/data/models/booking_model.dart';
import '../models/booking_with_barber_model.dart' show BookingWithBarberModel;
import 'fetch_barber_repo.dart';

abstract class FetchBookingAndBarberRepository {
  Stream<List<BookingWithBarberModel>> streamBookingsWithBarber({required String userId});
}

class FetchBookingAndBarberRepositoryImpl implements FetchBookingAndBarberRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final BarberService _barberService;

  FetchBookingAndBarberRepositoryImpl(this._barberService);

  @override
  Stream<List<BookingWithBarberModel>> streamBookingsWithBarber({required String userId}) {
    return _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .asyncMap<List<BookingWithBarberModel>>(_barberService.attachBarbersToBookings);
  }
}


class BarberService {
  final FetchBarberRepository _barberRepository;

  BarberService(this._barberRepository);

  Future<List<BookingWithBarberModel>> attachBarbersToBookings(QuerySnapshot snapshot) async {
    final futures = snapshot.docs.map((doc) async {
      try {
        final BookingModel booking = BookingModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
        final BarberModel barber = await _barberRepository.streamBarber(booking.barberId).first;
        return BookingWithBarberModel(booking: booking, barber: barber);
      } catch (e) {
        log('Error fetching barber for booking ID ${doc.id}: $e');
        return null;
      }
    });

    final results = await Future.wait(futures);
    final validBookings = results.whereType<BookingWithBarberModel>().toList();
    validBookings.sort((a, b) => b.booking.createdAt.compareTo(a.booking.createdAt));
    return validBookings;
  }
}
