import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wtsp_clone/controller/profile_provider.dart';
import 'package:wtsp_clone/fireBaseController/contact_provider.dart';
import 'package:wtsp_clone/fireBasemodel/models/user_model.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signIn(
      String email,
      String password,
      ProfileProvider profileProvider,
      FireBaseContactsProvider contactsProvider) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        await profileProvider.loadProfileData();
        await contactsProvider.fetchChatHistoryUsers();
      }
      return user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<User?> signUp(String name, String phone, String email, String password,
      ProfileProvider profileProvider,FireBaseContactsProvider contactsProvider) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
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
          aboutInfo: "Hey there! I'm using WhatsApp",
          createdAt: DateTime.now(),
        );
        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
        await profileProvider.loadProfileData();
        await contactsProvider.fetchChatHistoryUsers();
      }
      return user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<User?> signInWithGoogle(ProfileProvider profileProvider,FireBaseContactsProvider contactsProvider) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        DocumentReference userDoc =
            _firestore.collection('users').doc(user.uid);
        DocumentSnapshot docSnapshot = await userDoc.get();
        if (!docSnapshot.exists) {
          UserModel newUser = UserModel(
            uid: user.uid,
            firstName: user.displayName ?? '',
            email: user.email ?? '',
            phone: user.phoneNumber ?? '',
            photoURL: user.photoURL ?? '',
            aboutInfo: "Hey there! I'm using WhatsApp",
            createdAt: DateTime.now(),
          );
          await userDoc.set(newUser.toMap());
        }
        await profileProvider.loadProfileData();
        await contactsProvider.fetchChatHistoryUsers();
      }
      notifyListeners();
      return user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    notifyListeners();
  }
}
