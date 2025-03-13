import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  final ImagePicker _picker = ImagePicker();

  int get selectedIndex => _selectedIndex;

  void updateIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  // Future<void> captureImageFromCamera() async {
  //   try {
  //     final pickedFile = await _picker.pickImage(source: ImageSource.camera);

  //     if (pickedFile != null) {
  //       print("Image captured: ${pickedFile.path}");
  //     } else {
  //       print("No image selected");
  //     }
  //   } catch (e) {
  //     print("Error capturing image: $e");
  //   }
  // }
  Future<void> pickImageFromGallery() async {
  final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    print("Image selected: ${pickedFile.path}");
  }
}
}
