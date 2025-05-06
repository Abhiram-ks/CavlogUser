import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_panel/app/data/models/slot_model.dart';

abstract class SlotChekingRepository {
  Future<bool> slotCheking({required String barberId, required List<SlotModel> selectedSlots});
  Future<bool> slotBooking({required String barberId, required List<SlotModel> selectedSlots});
}

class SlotCheckingRepositoryImpl implements SlotChekingRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  @override
  Future<bool> slotCheking({required String barberId, required List<SlotModel> selectedSlots}) async {

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

      final data = snapshot.data()!;
      final isAvailable = data['available'] == true;
      final isNotBooked = data['booked'] == false;
      
      if (!isAvailable || !isNotBooked) {
          log('Slot booking failed: $data');
          return false;
        }
     }
       return true;
    } catch (e) {
      return false;
    }
  }

   @override
   Future<bool>  slotBooking({required String barberId, required List<SlotModel> selectedSlots}) async {
    WriteBatch batch = firestore.batch();

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

      final data = snapshot.data()!;
      final isAvailable = data['available'] == true;
      final isNotBooked = data['booked'] == false;

       if (!isAvailable || !isNotBooked) {
          log('Slot booking failed: $data');
          return false;
        }
      batch.update(docRef, {
        'available': false,
        'booked': true,
      });
    }

    try {
      await batch.commit();
      return true;
   }catch(e){
    log('that willbe working yes');
     return false;
   }
   }
}

