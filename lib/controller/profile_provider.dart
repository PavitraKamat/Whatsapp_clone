import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wtsp_clone/data/dataSources/wtsp_db.dart';

class ProfileProvider extends ChangeNotifier {
  Uint8List? _image;
  String _name = "Alice";
  String _status = "Hey there! I'm using WhatsApp";
  String _phoneNumber = "+91 9876543210";
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
    final profile = await WtspDb.instance.getProfile();
    if (profile.isNotEmpty) {
      String? imagePath = profile['imagePath'];
      Uint8List? imageBytes;
      if (imagePath != null && imagePath.isNotEmpty) {
        File imgFile = File(imagePath);
        if (await imgFile.exists()) {
          imageBytes = await imgFile.readAsBytes();
        }
      }
      _name = profile['name'] ?? _name;
      _status = profile['status'] ?? _status;
      _imagePath = imagePath;
      _image = imageBytes;
      notifyListeners();
    }
  }

  Future<void> _saveProfileData() async {
    if (_imagePath == null) return;
    await WtspDb.instance.saveProfile(_name, _status, _imagePath!);
  }

  void updateName(String newName) {
    _name = newName;
    _saveProfileData();
    notifyListeners();
  }

  void updateStatus(String newStatus) {
    _status = newStatus;
    _saveProfileData();
    notifyListeners();
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
    _saveProfileData();
    notifyListeners();
  }
}
