import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';


abstract class ChengeSlotStatusRepository {
  Future<bool> chengeStatus({
    required String barberId,
    required String docId,
    required List<String> slotId,
  });
}

class ChengeSlotStatusRepositoryImple implements ChengeSlotStatusRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<bool> chengeStatus({
    required String barberId,
    required String docId,
    required List<String> slotId,
  }) async {
    log('barber id : $barberId, and the doc id is $docId, then the slotid is : $slotId');
    try {
      DocumentReference dateDocRef = _firestore
          .collection('slots')
          .doc(barberId)
          .collection('dates')
          .doc(docId);

      DocumentSnapshot slotDocSnapshot = await dateDocRef.get();
      log('snapshot is find so it like $slotDocSnapshot');
      if (!slotDocSnapshot.exists) {
        return false;
      }

      WriteBatch batch = _firestore.batch();

      for (String slotDocId in slotId) {
        final slotRef = dateDocRef.collection('slot').doc(slotDocId); 
        batch.update(slotRef, {
          'booked': false,
          'available': true,
        });
      }

      await batch.commit();
      return true;
    } catch (e) {
      log('Error updating slot status: $e');
      return false;
    }
  }
}
