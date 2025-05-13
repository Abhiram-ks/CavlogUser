import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_panel/app/data/models/wallet_model.dart';

abstract class RefundCancelRepositoryDatasource {
  Future<bool> barberWallet({required String barberId, required double amount});
  Future<bool> userWallet({required String userId, required  double amount});
  Future<bool> getUserWallet({required String userId, required double amount});
} 

class RefundCancelRepositoryDatasourceImpl implements RefundCancelRepositoryDatasource {
   final FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  @override
  Future<bool> barberWallet({required String barberId, required double amount}) async {
    try {
       final walletRef = firestore.collection('shop_wallet').doc(barberId);
      final docSnapshot = await walletRef.get();

      if (!docSnapshot.exists) {
        return false;
      }

      final data = docSnapshot.data()!;
      final double currentTotal = (data['lifetime_amount'] as num?)?.toDouble() ?? 0.0;
     
      if (currentTotal < amount) {
        return false;
      }

      final updatedAmount = currentTotal - amount;
      await walletRef.update({
        'lifetime_amount': updatedAmount,
        'updated': Timestamp.now(),
      });


      return true;

    } catch (e) {
      log('Refundig fetching barber wallet error :$e');
      return false;
    }
  }

   @override
   Future<bool> getUserWallet({required String userId, required double amount}) async {
    try {
      final walletRef = firestore.collection('user_wallet').doc(userId);
     final docSnapshot = await walletRef.get();

     final data = docSnapshot.data()!;
     final double currentTotal = (data['totalAmount'] as num?)?.toDouble() ?? 0.0;
    
      double updatedAmount;
     if (amount > currentTotal) {
       updatedAmount = 0.0;
     }else {
      updatedAmount = currentTotal - amount;
     }

       await walletRef.update({
      'totalAmount': updatedAmount,
      'updated': Timestamp.now(),
    });
      
      return true;

    } catch (e) {
      return false;
    }
   }
   @override
Future<bool> userWallet({required String userId, required double amount}) async {
  try {
    final walletRef = firestore.collection('user_wallet').doc(userId);
    final docSnapshot = await walletRef.get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data()!;
      final double currentTotal = (data['totalAmount'] as num?)?.toDouble() ?? 0.0;
      final double updatedAmount = currentTotal + amount;

      await walletRef.update({
        'totalAmount': updatedAmount,
        'updated': Timestamp.now(),
      });
    } else {
      await walletRef.set(WalletModel(
        userId: userId,
        totalAmount: amount,
        updated: DateTime.now(),
        history: {},
      ).toMap());
    }

    return true;
  } catch (e) {
    log("User wallet update error: $e");
    return false;
  }
 }
}