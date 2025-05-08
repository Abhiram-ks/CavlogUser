import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_panel/app/data/models/wishlist_model.dart';

abstract class WishlistRemoteDatasources {
  Future<void> addLike({required String userId, required String barberId});
  Future<void> unLike({required String userId, required String barberId});
}

class WishlistRemoteDatasourcesImpl implements WishlistRemoteDatasources {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<void> addLike({required String userId, required String barberId}) async {
       final docId = '${userId}_$barberId';
      final docRef = firestore.collection('wishlists').doc(docId);

      final data = WishlistModel(
        userId: userId,
        shopId: barberId,
        likedAt: DateTime.now(),
      );

      await docRef.set(data.toMap());
  }

  @override
  Future<void> unLike({required String userId, required String barberId}) async {
     final docId = '${userId}_$barberId';
     final docRef = FirebaseFirestore.instance.collection('wishlists').doc  (docId);
     await docRef.delete();
  }
}
