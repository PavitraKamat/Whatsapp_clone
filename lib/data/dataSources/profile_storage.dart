// import 'dart:convert';
// import 'dart:io';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:path_provider/path_provider.dart';

// class ProfileStorage {
//   static const String _keyName = 'user_name';
//   static const String _keyStatus = 'user_status';
//   static const String _keyProfileImage = 'profile_image_path';

//   static Future<void> saveProfile(
//       String name, String status, String imagePath) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_keyName, name);
//     await prefs.setString(_keyStatus, status);
//     await prefs.setString(_keyProfileImage, imagePath);
//   }

//   static Future<Map<String, String?>> getProfile() async {
//     final prefs = await SharedPreferences.getInstance();
//     return {
//       'name': prefs.getString(_keyName),
//       'status': prefs.getString(_keyStatus),
//       'imagePath': prefs.getString(_keyProfileImage),
//     };
//   }

//   static Future<String> saveImageToLocal(File imageFile) async {
//     final directory = await getApplicationDocumentsDirectory();
//     final String imagePath = '${directory.path}/profile_image.png';
//     await imageFile.copy(imagePath);
//     return imagePath;
//   }
// }
