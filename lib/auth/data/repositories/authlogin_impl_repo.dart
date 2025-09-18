
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_panel/auth/data/models/user_model.dart';
import 'package:user_panel/core/common/custom_hashing_class.dart';

abstract class AuthRepositoryLogin {
  Stream<UserModel?> login(String email, String password);
}

class AuthRepositoryImplLogin implements AuthRepositoryLogin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<UserModel?> login(String email, String password) async* {
    try {
      final String hashedPassword = Hashfunction.generateHash(password);
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: hashedPassword,
      );

      final User? user = userCredential.user;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'no-user',
          message: 'No user returned from Firebase.',
        );
      }

      if (!user.emailVerified) {
        await user.sendEmailVerification();
        throw FirebaseAuthException(
          code: 'email-not-verified',
          message: 'Please verify your email. A new verification link has been sent.',
        );
      }

      final DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists || userDoc.data() == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'User data not found in Firestore.',
        );
      }

      final userModel = UserModel.fromMap(user.uid, userDoc.data()!);
      yield userModel;
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
