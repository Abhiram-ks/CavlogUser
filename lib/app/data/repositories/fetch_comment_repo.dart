import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_panel/app/data/models/comment_model.dart';

abstract class SendCommentRepository {
  Stream<List<CommentModel>> fetchComments({required String barberId, required String docId});
}

class SendCommentRepositoryImpl implements SendCommentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<CommentModel>> fetchComments({
    required String barberId,
    required String docId,
  }) {
    return _firestore
        .collection('comments')
        .where('postDocId', isEqualTo: docId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          if (snapshot.docs.isEmpty) return [];

          final commentDocs = snapshot.docs;
          final commentModels = await Future.wait(commentDocs.map((doc) async {
            final commentData = doc.data();

            final userId = commentData['userId'];
            final userSnapshot = await _firestore.collection('users').doc(userId).get();

            final userData = userSnapshot.exists
                ? userSnapshot.data() ?? {}
                : {'userName': 'Unknown', 'image': ''};

            return CommentModel.fromData(
              commentData: commentData,
              userData: userData,
            );
          }));

          return commentModels;
        });
  }
}
