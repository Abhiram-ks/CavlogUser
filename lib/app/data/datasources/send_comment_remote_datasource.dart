import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

abstract class SendCommentRemoteDatasource {
  Future<bool> sendComment({required String userId, required String comment, required String docId, required String barberId});
}
// This file is part of the project and is used to send comments to a specific post in Firestore.
// It defines an interface for sending comments and implements the functionality using Firestore.
class SendCommentRemoteDatasourceImpl implements SendCommentRemoteDatasource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<bool> sendComment({
    required String userId,
    required String comment,
    required String docId,
    required String barberId,
  }) async {
    try {
      final postDocRef = firestore.collection('comments').doc(); // Auto-generated ID

      await postDocRef.set({
        'docId': postDocRef.id,             
        'postDocId': docId,               
        'userId': userId,
        'barberId': barberId,
        'comment': comment,
        'createdAt': FieldValue.serverTimestamp(), 
        'likes': [],                             
      });

      return true;
    } catch (e) {
      log('Error sending comment: $e');
      return false;
    }
  }
}
