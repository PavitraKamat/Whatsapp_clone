import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/controller/google_sign_in_provider.dart';
import 'package:wtsp_clone/view/screens/login/login_screen.dart';

class ProfileProvider extends ChangeNotifier {
  Uint8List? _image;
  String _name = "";
  String _status = "Hey there! I'm using WhatsApp";
  String _phoneNumber = "";
  String? _imagePath;

  Uint8List? get image => _image;
  String get name => _name;
  String get status => _status;
  String get phoneNumber => _phoneNumber;
  String? get imagePath => _imagePath;

  ProfileProvider() {
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          _name = userDoc['firstName'] ?? _name;
          _status = userDoc['status'] ?? _status;
          _phoneNumber = user.phoneNumber ?? "";
          _imagePath = userDoc['photoURL'];
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
        'name': newName,
      });
      _name = newName;
      notifyListeners();
    }
  }

  Future<void> updateStatus(String newStatus) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'status': newStatus,
      });
      _status = newStatus;
      notifyListeners();
    }
  }

  Future<void> selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Uint8List imgBytes = await pickedFile.readAsBytes();
      await _saveImage(imgBytes);
    }
  }

  Future<void> _saveImage(Uint8List imageBytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/profile_image.png';
    File file = File(filePath);
    await file.writeAsBytes(imageBytes);
    _imagePath = filePath;
    _image = imageBytes;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'imagePath': filePath,
      });
    }
    notifyListeners();
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
