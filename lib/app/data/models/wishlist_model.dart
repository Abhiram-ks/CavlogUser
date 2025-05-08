import 'package:cloud_firestore/cloud_firestore.dart';

class WishlistModel {
  final String userId;
  final String shopId;
  final DateTime likedAt;

  WishlistModel({
    required this.userId,
    required this.shopId,
    required this.likedAt,
  });

  factory WishlistModel.fromMap(Map<String, dynamic> data) {
    return WishlistModel(
      userId: data['userId'] ?? '',
      shopId: data['shopId'] ?? '',
      likedAt: (data['likedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'shopId': shopId,
      'likedAt': Timestamp.fromDate(likedAt),
    };
  }
}
