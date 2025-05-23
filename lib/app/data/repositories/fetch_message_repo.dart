import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:user_panel/app/data/models/barber_model.dart';
import 'package:user_panel/app/data/repositories/fetch_barber_repo.dart';

abstract class FetchMessageAndBarberRepo {
  Stream<List<BarberModel>> streamChat({required String userid});
}

class MessageRepositoryImpl implements FetchMessageAndBarberRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FetchBarberRepository _repository;

  MessageRepositoryImpl(this._repository);

  @override
  Stream<List<BarberModel>> streamChat({required String userid}) {
    return _firestore
        .collection('chat')
        .where('userId', isEqualTo: userid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .switchMap((querySnapshot) {
      final barberIds = querySnapshot.docs
          .map((doc) => doc.data()['barberId'] as String?)
          .whereType<String>()
          .toSet()
          .toList();

      if (barberIds.isEmpty) {
        return Stream.value(<BarberModel>[]);
      }


      final barberStreams = barberIds
          .map((id) => _repository.streamBarber(id)
              .handleError((e) {
                log('Error streaming barber $id: $e');
              }))
          .toList();

      return Rx.combineLatestList<BarberModel>(barberStreams);
    });
  }
}