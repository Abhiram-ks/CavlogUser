import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LikePostCubit extends Cubit<void> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  LikePostCubit() : super(null);

  Future<void> toggleLike({
    required String barberId,
    required String postId,
    required String userId,
    required List<String> currentLikes,
  }) async {
    final postRef = _firestore
        .collection('posts')
        .doc(barberId)
        .collection('Post')
        .doc(postId);
    

    final isLiked = currentLikes.contains(userId);
    
    try {
      await postRef.update({
        'likes': isLiked
            ? FieldValue.arrayRemove([userId])
            : FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      log('Error toggling like: $e');
    }
  }
}
