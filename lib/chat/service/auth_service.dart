import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? getCurrentUserEmail() {
    return _auth.currentUser;
  }

}
