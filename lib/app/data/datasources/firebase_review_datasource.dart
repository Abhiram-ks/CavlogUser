
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';


abstract class ReviewRemoteDatasources {
  Future<String?> takeReview({required String userId});
}

class ReviewRemoteDatasourcesImpl implements ReviewRemoteDatasources {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<String?> takeReview({required String userId}) async {
    try {
      final querySnapshot = await _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .where('service_status', isEqualTo: 'Completed')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    }

    final bookingDoc = querySnapshot.docs.first;
    final String barberId = bookingDoc['barberId'] as String;

    final reviewSnapshot = await _firestore
        .collection('reviews')
        .doc(barberId)
        .collection('shop_reviews')
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    if (reviewSnapshot.docs.isNotEmpty) {
      log('The userAlredy reviewed so no need another reviews');
      return null;
    }
   
    log('return the barberid is:$barberId');
    return barberId;
  } 
   catch (e) {
    return null;
   }
  }
    
}
