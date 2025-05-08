import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:user_panel/app/data/repositories/fetch_barber_repo.dart';
import '../models/barber_model.dart' show BarberModel;
import '../models/post_model.dart';
import '../models/post_with_barber_model.dart';

class PostService {
  final FetchBarberRepository _barberRepository;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  PostService(this._barberRepository);

  Stream<List<PostWithBarberModel>> fetchAllPostsWithBarbers() {
    return _barberRepository.streamAllBarbers().switchMap((barberList) {
      if (barberList.isEmpty) {
        return Stream.value([]);
      }

      final postWithBarberStreams = barberList
          .map(_mapBarberToPostStream)
          .cast<Stream<List<PostWithBarberModel>>>();

      return Rx.combineLatestList(postWithBarberStreams).map(
        (combined) => combined.expand((e) => e).toList(),
      );
    });
  }

  Stream<List<PostWithBarberModel>> _mapBarberToPostStream(BarberModel barber) {
    final postsRef = _firestore
        .collection('posts')
        .doc(barber.uid)
        .collection('Post')
        .orderBy('createdAt', descending: true);

    return postsRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final post = PostModel.fromDocument(barber.uid, doc);
        return PostWithBarberModel(post: post, barber: barber);
      }).toList();
    });
  }
}
