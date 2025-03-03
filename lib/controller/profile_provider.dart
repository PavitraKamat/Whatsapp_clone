// import 'dart:typed_data';
// import 'package:flutter/material.dart';

// class ProfileProvider with ChangeNotifier {
//   Uint8List? _image;
//   String _name;
//   String _status;

//   ProfileProvider(
//       {Uint8List? image, required String name, required String status})
//       : _image = image,
//         _name = name,
//         _status = status;

//   Uint8List? get image => _image;
//   String get name => _name;
//   String get status => _status;

//   void updateImage(Uint8List? newImage) {
//     _image = newImage;
//     notifyListeners();
//   }

//   void updateName(String newName) {
//     _name = newName;
//     notifyListeners();
//   }

//   void updateStatus(String newStatus) {
//     _status = newStatus;
//     notifyListeners();
//   }
// }
