import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/controller/google_sign_in_provider.dart';
import 'package:wtsp_clone/view/screens/login/login_screen.dart';

class ProfileProvider extends ChangeNotifier {
  String _name = "";
  String _about = "Hey there! I'm using WhatsApp";
  String _phoneNumber = "";
  String? _imageUrl;

  String get name => _name;
  String get about => _about;
  String get phoneNumber => _phoneNumber;
  String? get imageUrl => _imageUrl;

  ProfileProvider() {
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          _name = userDoc['firstName'] ?? _name;
          _about = userDoc['aboutInfo'] ?? _about;
          _phoneNumber = userDoc['phone'] ?? _phoneNumber;
          _imageUrl = userDoc['photoURL'];
          notifyListeners();
        }
      } catch (e) {
        debugPrint("Error fetching profile data: $e");
      }
    }
  }

  Future<void> updateName(String newName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'firstName': newName,
      });
      _name = newName;
      notifyListeners();
    }
  }

  Future<void> updateStatus(String newAbout) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'aboutInfo': newAbout,
      });
      _about = newAbout;
      notifyListeners();
    }
  }

  Future<void> updatePhone(String newPhone) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'phone': newPhone,
      });
      _phoneNumber = newPhone;
      notifyListeners();
    }
  }
  Future<void> selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path); // Convert to File
      await _uploadImage(imageFile);
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // Reference to Firebase Storage
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child('${user.uid}.jpg');

      // Upload file directly
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      // Get Download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();
      _imageUrl = downloadUrl;

      // Save URL in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'photoURL': downloadUrl,
      });

      notifyListeners();
    } catch (e) {
      debugPrint("Error uploading image: $e");
    }
  }
  void logout(BuildContext context) async {
    try {
      final provider =
          Provider.of<GoogleSignInProvider>(context, listen: false);
      await provider.signOut();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Logout Failed: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
