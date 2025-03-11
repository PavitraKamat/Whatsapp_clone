import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wtsp_clone/data/models/user_model.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _user;
  User? get user => _user;

  Future<User?> googleLogin() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User canceled sign-in

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      _user = userCredential.user;

      if (_user != null) {
        DocumentReference userDoc =
            _firestore.collection('users').doc(_user!.uid);
        DocumentSnapshot docSnapshot = await userDoc.get();

        if (!docSnapshot.exists) {
          UserModel newUser = UserModel(
            uid: _user!.uid,
            firstName: _user!.displayName?.split(' ')[0] ?? '',
            email: _user!.email ?? '',
            phone: _user!.phoneNumber ?? '',
            photoURL: _user!.photoURL ?? '',
            createdAt: DateTime.now(),
          );
          await userDoc.set(newUser.toMap());
        }
      }
      notifyListeners(); // Notify UI about login
      return _user;
    } catch (e) {
      print("Error during Google Sign-In: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      _user = null;
      notifyListeners(); // Notify UI about sign-out
    } catch (e) {
      print("Error during Sign-Out: $e");
    }
  }

  Future<UserModel?> getUserDetails(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print("Error fetching user details: $e");
      return null;
    }
  }
}

