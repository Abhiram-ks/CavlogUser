import 'package:cloud_firestore/cloud_firestore.dart';


class DeleteMessage {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 
  Future<void> hardDeleteMessage(String docId) async {
    try {
      final docRef = _firestore.collection('chat').doc(docId);

       docRef.update(({
        'delete': true,
       }));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> softDelete(String docId) async {
    try {
      final docRef = _firestore.collection('chat').doc(docId);

      docRef.update(({
      'softDelete': true,
      }));
    } catch (e) {
      rethrow;
    }
  }
}