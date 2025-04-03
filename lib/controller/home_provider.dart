import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeProvider extends ChangeNotifier with WidgetsBindingObserver {
  int _selectedIndex = 0;
  bool _isFirebaseView = true;
  final ImagePicker _picker = ImagePicker();

  int get selectedIndex => _selectedIndex;
  bool get isFirebaseView => _isFirebaseView;

  HomeProvider() {
    _loadPreference();
    WidgetsBinding.instance.addObserver(this);  // Adding observer
    _updateOnlineStatus(true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);  // Removing observer
    _updateOnlineStatus(false);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _updateOnlineStatus(true);
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _updateOnlineStatus(false);
    }
  }

  Future<void> _updateOnlineStatus(bool isOnline) async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'isOnline': isOnline,
      'lastSeen': isOnline ? 'online' : Timestamp.now(),
    });
  }

  void _loadPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isFirebaseView = prefs.getBool('isFirebaseView') ?? true;
    notifyListeners();
  }

  void updateIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  Future<void> toggleView(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirebaseView', value);
    _isFirebaseView = value;
    notifyListeners();
  }

  Future<void> pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      print("Image selected: ${pickedFile.path}");
    }
  }
}

