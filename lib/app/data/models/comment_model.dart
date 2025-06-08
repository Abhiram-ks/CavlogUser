           

import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String userId;
  final String docId;
  final String postDocId;
  final String barberId;
  final String description;
  final List<String> likes;
  final String userName;
  final String imageUrl;
  final DateTime createdAt;

  CommentModel({
    required this.barberId,
    required this.userId,
    required this.userName,
    required this.imageUrl,
    required this.description,
    required this.docId,
    required this.likes,
    required this.postDocId,
    required this.createdAt,
  });

  factory CommentModel.fromData({
    required Map<String, dynamic> commentData,
    required Map<String, dynamic> userData,
  }) {
    return CommentModel(
      createdAt: (commentData['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(), 
      userId: commentData['userId'] ?? '',
      likes: List<String>.from(commentData['likes'] ?? []), 
      docId: commentData['docId'] ?? '',
      description: commentData['comment'] ?? '',
      barberId: commentData['barberId'] ?? '',
      postDocId: commentData['postDocId'] ?? '',
      imageUrl: userData['image'] ?? '',
      userName: userData['userName'] ?? '',
    );
  }
}
