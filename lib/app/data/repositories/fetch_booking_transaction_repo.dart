
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_panel/app/data/models/booking_model.dart';

abstract class FetchBookingTransactionRepository {
  Stream<List<BookingModel>> streamBookings({required String userId});
  Stream<List<BookingModel>> streamBookingsFilter({required String userId, required String status});
}

class FetchBookingRepositoryImpl implements FetchBookingTransactionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<BookingModel>> streamBookings({required String userId}) {
    final bookingQuery =
        _firestore.collection('bookings').where('userId', isEqualTo: userId);

    return bookingQuery.snapshots().map((snapshot) {
      try {
        final bookings = snapshot.docs.map((doc) {
          final booking = BookingModel.fromMap(doc.id, doc.data());
          return booking;
        }).toList();

        bookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return bookings;
      } catch (e) {
        return <BookingModel>[];
      }
    });
  }

    @override
  Stream<List<BookingModel>> streamBookingsFilter({required String userId, required String status}){
    final bookingQuery =
        _firestore.collection('bookings')
        .where('userId', isEqualTo: userId)
        .where('transaction', isEqualTo: status);

    return bookingQuery.snapshots().map((snapshot) {
      try {
        final bookings = snapshot.docs.map((doc) {
          final booking = BookingModel.fromMap(doc.id, doc.data());
          return booking;
        }).toList();

        bookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return bookings;
      } catch (e) {
        return <BookingModel>[];
      }
    });
  }
}
