import 'package:cloud_firestore/cloud_firestore.dart';

abstract class RequestForChatupdateRepository {
  Future<void> chatStatusChange({required String userId, required String barberId});
}

class RequestForChatupdateRepoImpl implements RequestForChatupdateRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> chatStatusChange({
    required String userId,
    required String barberId,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection('chat')
          .where('userId', isEqualTo: userId)
          .where('barberId', isEqualTo: barberId)
          .where('senderId', isEqualTo: barberId)
          .where('isSee', isEqualTo: false)
          .get();

      if (querySnapshot.docs.isEmpty) return;

      final batch = _firestore.batch();

      querySnapshot.docs
          .where((doc) => doc['isSee'] == false)
          .map((doc) => batch.update(doc.reference, {'isSee': true}))
          .toList();

      await batch.commit();
    } catch (e) {
      rethrow;
    }
  }
}
