import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class WalletPaymentRepository {
  Future<bool> walletPayment({required String userId, required double bookingAmount});
}


class WalletPaymentRepositoryImpl implements  WalletPaymentRepository{
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<bool> walletPayment({required String userId, required double bookingAmount}) async{
    try {
       final walletRef = _firebaseFirestore.collection('user_wallet').doc(userId);
       final docSnapshot = await walletRef.get();

       if (!docSnapshot.exists) {
        log('[WalletPayment] Wallet not found for user: $userId');
        return false;
      }

       final data = docSnapshot.data()!;
       final currentBalance = (data['totalAmount'] as num?)?.toDouble() ?? 0.0;
       final updatedBalance = (currentBalance >= bookingAmount) ? (currentBalance - bookingAmount) : 0.00;

       await walletRef.update({
        'totalAmount': updatedBalance,
        'updated': DateTime.now(), 
       });
       return true;
    } catch (e) {
      log('Message unexpected error occurred due to : $e');
      return false;
    }
  }
}