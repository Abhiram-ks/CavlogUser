import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../models/wallet_model.dart';

abstract class WalletRepositoryDataSources {
  Future<bool> updateWallet({required String userId, required  double amount});
}

class WalletRepositoryDataSourcesImpl implements WalletRepositoryDataSources {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<bool> updateWallet({required String userId, required double amount}) async {
    try {
      final walletRef = firestore.collection('user_wallet').doc(userId);
      final docSnapshot = await walletRef.get();
      double newTotalAmount = amount;
      final formattedDate = DateFormat('dd/MM/yyyy - HH:mm').format(DateTime.now());

      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        final currentTotal = (data['totalAmount'] as num?)?.toDouble() ?? 0.0;

        newTotalAmount = currentTotal + amount;
        if (newTotalAmount < 0) throw Exception("Total wallet amount cannot be negative.");

        final Map<String, dynamic> rawHistory = Map<String, dynamic>.from(data['history'] ?? {});
        final parsedHistory = rawHistory.map((k, v) => MapEntry(k, (v as num).toDouble()));
        parsedHistory[formattedDate] = amount;

        await walletRef.update({
          'totalAmount': newTotalAmount,
          'updated': DateTime.now(),
          'history': parsedHistory,
        });
      } else {
        await walletRef.set(WalletModel(
          userId: userId,
          totalAmount: amount,
          updated: DateTime.now(),
          history: {formattedDate: amount},
        ).toMap());
      }

      return true;
    } catch (e) {
      log("Wallet update error: $e");
      return false;
    }
  }
}