
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LikeCommentCubit extends Cubit<void> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  LikeCommentCubit() : super(null);

  Future<void> toggleLike({
    required String userId,
    required String docId,
    required List<String> currentLikes,
  }) async {
    final commentDoc = _firestore
      .collection('comments')
      .doc(docId);

   final isLiked = currentLikes.contains(userId);
    try {
      await commentDoc.update({
        'likes' : isLiked 
            ? FieldValue.arrayRemove([userId])
            : FieldValue.arrayUnion([userId])
      });
    } catch (e) {
      Exception('$e');
    }
  }
}