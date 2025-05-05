import 'package:cloud_firestore/cloud_firestore.dart';

abstract class WalletTransactionRemoteDataSource {
  Future<bool> barberWalletUpdate({required String barberId, required  double amount});
  Future<bool> platformFreeUpdate({required double platformFee});
}

class WalletTransactionRemoteDataSourceImpl implements WalletTransactionRemoteDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<bool> barberWalletUpdate({required String barberId, required double amount}) async {
    try {
      final walletRef = firestore.collection('shop_wallet').doc(barberId);
      final docSnapshot = await walletRef.get();

      double newTotalAmount = amount;

      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        final currentTotal = (data['lifetime_amount'] as num?)?.toDouble() ?? 0.0;

        newTotalAmount = currentTotal + amount;

        await walletRef.update({
          'lifetime_amount': newTotalAmount,
          'updated': Timestamp.now(),
        });
      } else {
        await walletRef.set({
          'barberId': barberId,
          'lifetime_amount': amount,
          'Redeemed': 0.0,
          'updated': Timestamp.now(),
        });
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> platformFreeUpdate({required double platformFee}) async {
    try {
       final walletRef = firestore.collection('platform_free').doc('wallet');
      final docSnapshot = await walletRef.get();

      double newTotalAmount = platformFee;

      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        final currentTotal = (data['lifetime_amount'] as num?)?.toDouble() ?? 0.0;

        newTotalAmount = currentTotal + platformFee;

        await walletRef.update({
          'lifetime_amount': newTotalAmount,
          'updated': Timestamp.now(),
        });
      } else {
        await walletRef.set({
          'lifetime_amount': platformFee,
          'Redeemed': 0.0,
          'updated': Timestamp.now(),
        });
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
