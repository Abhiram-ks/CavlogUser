import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_panel/app/data/models/wallet_model.dart';
import 'package:flutter/foundation.dart';


abstract class FetchWalletsRepository {
  Stream<WalletModel?> streamWalletFetch({required String userId});
}

class FetchWalletsRepositoryImpl implements FetchWalletsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<WalletModel?> streamWalletFetch({required String userId}) {
    try {
      return _firestore
          .collection('user_wallet')
          .doc(userId)
          .snapshots()
          .map((doc) {
            if (doc.exists && doc.data() != null) {
                return WalletModel.fromMap(doc.data()!);
            }
            return null;
          })
          .handleError((error, stackTrace) {
            debugPrint('Firestore stream error: $error\n$stackTrace');
          });
    } catch (e, stackTrace) {
      debugPrint('Error setting up wallet stream: $e\n$stackTrace');
      return const Stream<WalletModel?>.empty();
    }
  }
}
