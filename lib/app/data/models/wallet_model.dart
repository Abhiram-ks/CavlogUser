import 'package:cloud_firestore/cloud_firestore.dart';

class WalletModel {
  final String userId;
  final double totalAmount;
  final DateTime updated;
  final Map<String, double> history;

  WalletModel({
    required this.userId,
    required this.totalAmount,
    required this.updated,
    required this.history,
  });

  factory WalletModel.fromMap(Map<String, dynamic> map) {
    final rawHistory = Map<String, dynamic>.from(map['history'] ?? {});
    final parsedHistory = rawHistory.map(
      (key, value) => MapEntry(key, (value as num).toDouble()),
    );

    return WalletModel(
      userId: map['userId'] ?? '',
      totalAmount: (map['totalAmount'] as num?)?.toDouble() ?? 0.0,
      updated: (map['updated'] as Timestamp?)?.toDate() ?? DateTime.now(),
      history: parsedHistory,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'totalAmount': totalAmount,
      'updated': Timestamp.fromDate(updated),
      'history': history,
    };
  }
}
