import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_panel/app/data/models/banner_models.dart';


abstract class FetchBannerRepository {
  Stream<BannerModels> streamBanners(); 
}

class FetchBannerRepositoryImpl implements FetchBannerRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<BannerModels> streamBanners() {
    try {
      return _firestore
          .collection('banner_images')
          .doc('user_doc')
          .snapshots()
          .map((snapshot) {
        final data = snapshot.data() ?? {};
        return BannerModels.fromMap(data);
      });
    } catch (e) {
      rethrow;
    }
  }
}
