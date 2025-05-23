import 'package:cloud_firestore/cloud_firestore.dart';
class ChatModel {
  final String? docId; 
  final String senderId;
  final String userId;
  final String barberId;
  final String message;
  final DateTime createdAt;
  final DateTime updateAt;
  final bool isSee;
  final bool delete;
  final bool softDelete;

  ChatModel({
    this.docId,
    required this.senderId,
    required this.userId,
    required this.barberId,
    required this.message,
    required this.createdAt,
    required this.updateAt,
    required this.isSee,
    required this.delete,
    required this.softDelete,
  });

  factory ChatModel.fromMap(String docId, Map<String, dynamic> map) {
    return ChatModel(
      docId: docId,
      senderId: map['senderId'] ?? '',
      message: map['message'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updateAt: (map['updateAt'] as Timestamp).toDate(),
      isSee: map['isSee'] ?? false,
      delete: map['delete'] ?? false,
      softDelete: map['softDelete'] ?? false,
      userId: map['userId'] ?? '',
      barberId: map['barberId'] ?? ''
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'userId': userId,
      'barberId':barberId,
      'message': message,
      'createdAt': createdAt,
      'updateAt': updateAt,
      'isSee': isSee,
      'delete': delete,
      'softDelete': softDelete,
    };
  }
}
