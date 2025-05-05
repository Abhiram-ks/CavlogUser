import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_panel/app/data/models/slot_model.dart';


abstract class SlotCheckingRepository {
  Future<bool> slotChecking({
    required String barberId,
    required List<SlotModel> selectedSlots,
  });

  Future<bool> slotBooking({
    required String barberId,
    required List<SlotModel> selectedSlots,
  });
}

class SlotCheckingRepositoryImpl implements SlotCheckingRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<bool> slotChecking({
    required String barberId,
    required List<SlotModel> selectedSlots,
  }) async {
    try {
      final futures = selectedSlots.map((slot) async {
        final docRef = firestore
            .collection('slots')
            .doc(barberId)
            .collection('dates')
            .doc(slot.docId)
            .collection('slot')
            .doc(slot.subDocId);

        final snapshot = await docRef.get();
        if (!snapshot.exists) return false;

        final data = snapshot.data();
        final isAvailable = data?['available'] == true;
        final isNotBooked = data?['booked'] == false;

        return isAvailable && isNotBooked;
      });

      final results = await Future.wait(futures);

      return results.every((result) => result == true);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> slotBooking({
    required String barberId,
    required List<SlotModel> selectedSlots,
  }) async {
    final WriteBatch batch = firestore.batch();

    try {
      for (final slot in selectedSlots) {
        final docRef = firestore
            .collection('slots')
            .doc(barberId)
            .collection('dates')
            .doc(slot.docId)
            .collection('slot')
            .doc(slot.subDocId);

        final snapshot = await docRef.get();

        if (!snapshot.exists) return false;

        batch.update(docRef, {
          'available': false,
          'booked': true,
        });
      }

      await batch.commit();
      return true;
    } catch (e) {
      return false;
    }
  }
}
