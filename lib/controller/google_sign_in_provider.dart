import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wtsp_clone/controller/profile_provider.dart';
import 'package:wtsp_clone/fireBaseController/contact_provider.dart';
import 'package:wtsp_clone/fireBaseController/onetoone_chat_provider.dart';
import 'package:wtsp_clone/fireBasemodel/models/user_model.dart';

// class GoogleSignInProvider extends ChangeNotifier {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();

//   Future<User?> signIn(
//       String email,
//       String password,
//       ProfileProvider profileProvider,
//       FireBaseContactsProvider contactsProvider,
//       FireBaseOnetoonechatProvider chatProvider) async {
//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       User? user = userCredential.user;
//       if (user != null) {
//         await _postAuthSetup(
//             user.uid, profileProvider, contactsProvider, chatProvider);
//       }
//       notifyListeners();
//       return user;
//     } on FirebaseAuthException catch (e) {
//       throw Exception(e.code);
//     } catch (_) {
//       throw Exception('Login failed. Please try again.');
//     }
//   }

//   Future<User?> signUp(
//       String name,
//       String phone,
//       String email,
//       String password,
//       ProfileProvider profileProvider,
//       FireBaseContactsProvider contactsProvider,
//       FireBaseOnetoonechatProvider chatProvider) async {
//     try {
//       UserCredential userCredential =
//           await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       User? user = userCredential.user;
//       await user?.updateDisplayName(name);

//       if (user != null) {
//         UserModel newUser = UserModel(
//           uid: user.uid,
//           firstName: name,
//           email: email,
//           phone: phone,
//           photoURL: '',
//           aboutInfo: "Hey there! I'm using WhatsApp",
//           createdAt: DateTime.now(),
//         );
//         await _firestore.collection('users').doc(user.uid).set(newUser.toMap());

//         await _postAuthSetup(
//             user.uid, profileProvider, contactsProvider, chatProvider);
//       }
//       notifyListeners();
//       return user;
//     } on FirebaseAuthException catch (e) {
//       throw Exception(e.code);
//     } catch (_) {
//       throw Exception('Registration failed. Please try again.');
//     }
//   }

//   Future<User?> signInWithGoogle(
//       ProfileProvider profileProvider,
//       FireBaseContactsProvider contactsProvider,
//       FireBaseOnetoonechatProvider chatProvider) async {
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) return null;

//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       UserCredential userCredential =
//           await _auth.signInWithCredential(credential);
//       User? user = userCredential.user;

//       if (user != null) {
//         DocumentReference userDoc =
//             _firestore.collection('users').doc(user.uid);
//         DocumentSnapshot docSnapshot = await userDoc.get();
//         if (!docSnapshot.exists) {
//           UserModel newUser = UserModel(
//             uid: user.uid,
//             firstName: user.displayName ?? '',
//             email: user.email ?? '',
//             phone: user.phoneNumber ?? '',
//             photoURL: user.photoURL ?? '',
//             aboutInfo: "Hey there! I'm using WhatsApp",
//             createdAt: DateTime.now(),
//           );
//           await userDoc.set(newUser.toMap());
//         }
//         await _postAuthSetup(
//             user.uid, profileProvider, contactsProvider, chatProvider);
//       }
//       notifyListeners();
//       return user;
//     } on FirebaseAuthException catch (e) {
//       throw Exception(e.code);
//     } catch (_) {
//       throw Exception('Google Sign-In failed. Please try again.');
//     }
//   }

//   Future<void> signOut() async {
//     await _googleSignIn.signOut();
//     await _auth.signOut();
//     notifyListeners();
//   }

//   Future<void> _postAuthSetup(
//     String uid,
//     ProfileProvider profileProvider,
//     FireBaseContactsProvider contactsProvider,
//     FireBaseOnetoonechatProvider chatProvider,
//   ) async {
//     await chatProvider.updateLastSeen(uid, isOnline: true);
//     await profileProvider.loadProfileData();
//     await contactsProvider.fetchChatHistoryUsers();
//   }

  // String _getErrorMessage(FirebaseAuthException e) {
  //   //print('Firebase error code: ${e.code}');
  //   switch (e.code) {
  //     case 'user-not-found':
  //       return 'No user found with this email.';
  //     case 'invalid-credential':
  //       return 'Invalid credential';
  //     case 'wrong-password':
  //       return 'Incorrect password.';
  //     case 'email-already-in-use':
  //       return 'Email is already registered.';
  //     case 'invalid-email':
  //       return 'The email address is invalid.';
  //     case 'weak-password':
  //       return 'The password is too weak.';
  //     case 'network-request-failed':
  //       return 'Network error. Please check your connection.';
  //     default:
  //       return 'Something went wrong. Please try again.';
  //   }
  // }
//}

class GoogleSignInProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _auth.currentUser;

  Future<User?> signIn(
      String email,
      String password,
      ProfileProvider profileProvider,
      FireBaseContactsProvider contactsProvider,
      FireBaseOnetoonechatProvider chatProvider) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        await _postAuthSetup(
            user.uid, profileProvider, contactsProvider, chatProvider);
      }
      notifyListeners();
      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_getReadableAuthError(e.code));
    } catch (_) {
      throw Exception('Login failed. Please try again.');
    }
  }

  Future<User?> signUp(
      String name,
      String phone,
      String email,
      String password,
      ProfileProvider profileProvider,
      FireBaseContactsProvider contactsProvider,
      FireBaseOnetoonechatProvider chatProvider) async {
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

        await _postAuthSetup(
            user.uid, profileProvider, contactsProvider, chatProvider);
      }
      notifyListeners();
      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_getReadableAuthError(e.code));
    } catch (_) {
      throw Exception('Registration failed. Please try again.');
    }
  }

  Future<User?> signInWithGoogle(
      ProfileProvider profileProvider,
      FireBaseContactsProvider contactsProvider,
      FireBaseOnetoonechatProvider chatProvider) async {
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
        await _createUserIfNotExists(user);
        await _postAuthSetup(
            user.uid, profileProvider, contactsProvider, chatProvider);
      }
      notifyListeners();
      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_getReadableAuthError(e.code));
    } catch (_) {
      throw Exception('Google Sign-In failed. Please try again.');
    }
  }

  Future<void> _createUserIfNotExists(User user) async {
    DocumentReference userDoc = _firestore.collection('users').doc(user.uid);
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
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    notifyListeners();
  }

  Future<void> _postAuthSetup(
    String uid,
    ProfileProvider profileProvider,
    FireBaseContactsProvider contactsProvider,
    FireBaseOnetoonechatProvider chatProvider,
  ) async {
    await chatProvider.updateLastSeen(uid, isOnline: true);
    await profileProvider.loadProfileData();
    await contactsProvider.fetchChatHistoryUsers();
  }
  
  String _getReadableAuthError(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'This email is already registered. Please login instead.';
      case 'weak-password':
        return 'Password is too weak. Please use a stronger password.';
      case 'invalid-email':
        return 'Invalid email address format.';
      case 'network-request-failed':
        return 'Network error. Please check your connection and try again.';
      case 'too-many-requests':
        return 'Too many unsuccessful login attempts. Please try again later.';
      default:
        return errorCode;
    }
  }
} 
