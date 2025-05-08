import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_panel/app/data/models/booking_model.dart';

abstract class FetchSpecificBookingRepository {
  Stream<BookingModel> streamBooking({required String docId});
}

class FetchSpecificBookingRepositoryImpl
    implements FetchSpecificBookingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<BookingModel> streamBooking({required String docId}) {
    return _firestore
        .collection('bookings')
        .doc(docId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return BookingModel.fromMap(snapshot.id, snapshot.data()!);
      } else {
        throw Exception("Booking not found");
      }
    });
  }
}
