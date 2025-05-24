import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_panel/app/data/models/chat_model.dart';

abstract class FetchLastmessageRepository {
  Stream<ChatModel?> latestMessage({
    required String userId,
    required String barberId,
  });

  Stream<int> messageBadges({
    required String userId,
    required String barberId,
  });
}

class FetchLastmessageRepositoryImpl implements FetchLastmessageRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<ChatModel?> latestMessage({
    required String userId,
    required String barberId,
  }) {
    return _firestore
        .collection('chat')
        .where('userId', isEqualTo: userId)
        .where('barberId', isEqualTo: barberId)
        .where('softDelete', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      final doc = snapshot.docs.first;
      return ChatModel.fromMap(doc.id, doc.data());
    });
  }

  @override
  Stream<int> messageBadges({
    required String userId,
    required String barberId,
  }) {
    return _firestore
        .collection('chat')
        .where('userId', isEqualTo: userId)
        .where('barberId', isEqualTo: barberId)
        .where('senderId', isEqualTo: barberId)
        .where('isSee', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}
