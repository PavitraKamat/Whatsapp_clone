import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  bool _isFirebaseView = true;
  final ImagePicker _picker = ImagePicker();

  int get selectedIndex => _selectedIndex;
  bool get isFirebaseView => _isFirebaseView;

  HomeProvider() {
    _loadPreference();
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
