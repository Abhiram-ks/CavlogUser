import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_panel/app/data/models/barber_model.dart';
import 'package:user_panel/app/data/repositories/fetch_barber_repo.dart';

abstract class FetchWishlistRepository {
  Stream<List<BarberModel>> streamWishList({required String userId});
  Stream<bool> isBarberLikedStream(
      {required String userId, required String barberId});
}

class FetchWishlistRepositoryImpl implements FetchWishlistRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FetchBarberRepository _barberRepository;

  FetchWishlistRepositoryImpl(this._barberRepository);

  @override
  Stream<List<BarberModel>> streamWishList({required String userId}) async* {
    yield* _firestore
        .collection('wishlists')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .asyncMap((snapshot) async {
      final shopIds = snapshot.docs
          .map((doc) => doc['shopId'] as String?)
          .where((id) => id != null && id.trim().isNotEmpty)
          .cast<String>()
          .toList();

      if (shopIds.isEmpty) return [];

      final barberStreams =  shopIds.map((id) => _barberRepository.streamBarber(id).first);
      final barbers = await Future.wait(barberStreams);
      return barbers;
    });
  }

  @override
  Stream<bool> isBarberLikedStream(
      {required String userId, required String barberId}) {
    final docId = '${userId}_$barberId';
    return _firestore
        .collection('wishlists')
        .doc(docId)
        .snapshots()
        .map((snapshot) => snapshot.exists)
        .distinct();
  }
}
