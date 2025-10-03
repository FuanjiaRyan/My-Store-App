import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> registerNewUser(
    String email,
    String fullName,
    String password,
  ) async {
    String res = 'something went wrong';

    try {
      //we want to create the user in the authentication tab and then later in firestore
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await _firestore.collection('buyers').doc(userCredential.user!.uid).set({
        'fullName': fullName,
        'email': email,
        'profileImage': '',
        'uid': userCredential.user!.uid,
        'pinCode': '',
        'locality': '',
        'city': '',
        'state': '',
      });

      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //login user
  Future<String> loginUser(String email, String password) async {
    String res = 'something went wrong';

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
