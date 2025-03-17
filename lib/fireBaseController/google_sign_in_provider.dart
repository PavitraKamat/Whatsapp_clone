import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wtsp_clone/model/models/user_model.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

    Future<User?> signUp(String name, String phone, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      await user?.updateDisplayName(name);

      if (user != null) {
        UserModel newUser = UserModel(
          uid: user.uid,
          firstName: name,
          email: email,
          phone: phone,
          photoURL: '',
          createdAt: DateTime.now(),
        );
        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
      }
      return user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        DocumentReference userDoc = _firestore.collection('users').doc(user.uid);
        DocumentSnapshot docSnapshot = await userDoc.get();
        if (!docSnapshot.exists) {
          UserModel newUser = UserModel(
            uid: user.uid,
            firstName: user.displayName ?? '',
            email: user.email ?? '',
            phone: user.phoneNumber ?? '',
            photoURL: user.photoURL ?? '',
            createdAt: DateTime.now(),
          );
          await userDoc.set(newUser.toMap());
        }
      }
      //notifyListeners();
      return user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
//   Future<UserModel?> getUserDetails(String uid) async {
//     try {
//       DocumentSnapshot doc =
//           await _firestore.collection('users').doc(uid).get();
//       if (doc.exists) {
//         return UserModel.fromMap(doc.data() as Map<String, dynamic>);
//       }
//       return null;
//     } catch (e) {
//       print("Error fetching user details: $e");
//       return null;
//     }
//   }
// }

