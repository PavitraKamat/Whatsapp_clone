// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class PhoneauthProvider extends ChangeNotifier {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   String _verificationId = '';

//   String get verificationId => _verificationId;

//   Future<void> verifyPhoneNumber(
//       String phoneNumber, BuildContext context, Function onCodeSent) async {
//     try {
//       await _auth.verifyPhoneNumber(
//         phoneNumber: phoneNumber,
//         timeout: const Duration(seconds: 60),
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           await _auth.signInWithCredential(credential);
//           notifyListeners();
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Verification Failed: ${e.message}")),
//           );
//         },
//         codeSent: (String verificationId, int? resendToken) {
//           _verificationId = verificationId;
//           notifyListeners();
//           onCodeSent(verificationId); // Callback to navigate to OTP screen
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {
//           _verificationId = verificationId;
//           notifyListeners();
//         },
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: ${e.toString()}")),
//       );
//     }
//   }

//   Future<void> verifyOTP(String otp, BuildContext context) async {
//     try {
//       PhoneAuthCredential credential = PhoneAuthProvider.credential(
//           verificationId: _verificationId, smsCode: otp);
//       await _auth.signInWithCredential(credential);
//       notifyListeners();
//       Navigator.pushReplacementNamed(context, '/home');
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("OTP verification failed")),
//       );
//     }
//   }
// }
