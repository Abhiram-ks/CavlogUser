

import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/common/custom_hashing_class.dart';

Future<bool> deleteCurrentUserAuthOnly(String password) async {
  final FirebaseAuth auth = FirebaseAuth.instance;

  try {
    final User? user = auth.currentUser;

    if (user == null) {
      return false;
    }

    final String? email = user.email;
    if (email == null) {
      return false;
    }
    final String hashedPassword = Hashfunction.generateHash(password);
    final credential = EmailAuthProvider.credential(email: email, password: hashedPassword);
    await user.reauthenticateWithCredential(credential);
    await user.delete();
    return true;

  } on FirebaseAuthException {
    return false;
  } catch (e) {
    return false;
  }
}
