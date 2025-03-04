// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:wtsp_clone/data/dataSources/wtsp_db.dart';

// class SettingsProvider extends ChangeNotifier {
//   Uint8List? _image;
//   String _name = "Alice";
//   String _status = "Hey there! I'm using WhatsApp";
//   String _phoneNumber = "+91 9876543210";
//   String? _imagePath;

//   Uint8List? get image => _image;
//   String get name => _name;
//   String get status => _status;
//   String get phoneNumber => _phoneNumber;
//   //String? get ImagePath => _imagePath;

//   SettingsProvider() {
//     _loadProfileData();
//     _loadImage();
//   }

//   Future<void> _loadProfileData() async {
//     final profile = await WtspDb.instance.getProfile();

//     if (profile.isNotEmpty) {
//       String? imagePath = profile['imagePath'];
//       Uint8List? imageBytes;

//       if (imagePath != null && imagePath!.isNotEmpty) {
//         File imgFile = File(imagePath!);
//         if (await imgFile.exists()) {
//           imageBytes = await imgFile.readAsBytes();
//         } else {
//           print("Image file does not exist at path: $imagePath");
//         }
//       }
//       _name = profile['name'] ?? _name;
//       _status = profile['status'] ?? _status;
//       _imagePath = _imagePath;
//       _image = imageBytes;
//       notifyListeners();
//     }
//   }

//   Future<void> _saveProfileData() async {
//     if (_imagePath == null) return;
//     await WtspDb.instance.saveProfile(_name, _status, _imagePath!);
//   }

//   void selectImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       Uint8List imgBytes = await pickedFile.readAsBytes();
//       await _saveImage(imgBytes);
//     }
//   }

//   Future<void> _saveImage(Uint8List imageBytes) async {
//     final directory = await getApplicationDocumentsDirectory();
//     final filePath = '${directory.path}/profile_image.png';
//     File file = File(filePath);
//     await file.writeAsBytes(imageBytes);

//     _imagePath = filePath;
//     _image = imageBytes;
//     notifyListeners();

//     await _saveProfileData(); // Save path to DB
//   }

//   void _loadImage() async {
//     final directory = await getApplicationDocumentsDirectory();
//     final filePath = '${directory.path}/profile_image.png';
//     File file = File(filePath);

//     if (file.existsSync()) {
//       Uint8List imgBytes = await file.readAsBytes();
//       _image = imgBytes;
//       notifyListeners();
//       print("Loaded saved image.");
//     } else {
//       print("No saved image found.");
//     }
//   }

//   void updateName(String newName) {
//     _name = newName;
//     notifyListeners();
//     _saveProfileData();
//   }

//   void updateStatus(String newStatus) {
//     _status = newStatus;
//     notifyListeners();
//     _saveProfileData();
//   }
// }
