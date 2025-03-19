// import 'package:cloud_firestore/cloud_firestore.dart';

// class UserModel {
//   final String? uid;
//   final String firstName;
//   final String email;
//   final String phone;
//   final String photoURL;
//   final DateTime? createdAt;

//   UserModel({
//     required this.uid,
//     required this.firstName,
//     required this.email,
//     required this.phone,
//     required this.photoURL,
//     this.createdAt,
//   });

//   // Convert UserModel to a Map for Firestore
//   Map<String, dynamic> toMap() {
//     return {
//       'uid': uid,
//       'firstName': firstName,
//       'email': email,
//       'phone': phone,
//       'photoURL': photoURL,
//       'createdAt': createdAt ?? DateTime.now(),
//     };
//   }

//   // Create UserModel from Firestore data
//   factory UserModel.fromMap(Map<String, dynamic> map) {
//     return UserModel(
//       uid: map['uid'] ?? '',
//       firstName: map['firstName'] ?? '',
//       email: map['email'] ?? '',
//       phone: map['phone'] ?? '',
//       photoURL: map['photoURL'] ?? '',
//       createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String firstName;
  final String email;
  final String phone;
  final String photoURL;
  final DateTime? createdAt;
  final String? lastMessage;
  final DateTime? lastMessageTime;

  UserModel({
    required this.uid,
    required this.firstName,
    required this.email,
    required this.phone,
    required this.photoURL,
    this.createdAt,
    this.lastMessage,
    this.lastMessageTime,
  });

  /// Convert UserModel to Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'email': email,
      'phone': phone,
      'photoURL': photoURL,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime != null ? Timestamp.fromDate(lastMessageTime!) : null,
    };
  }

  /// Convert Firestore Map to UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      firstName: map['firstName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      photoURL: map['photoURL'] ?? '',
      createdAt: map['createdAt'] is Timestamp ? (map['createdAt'] as Timestamp).toDate() : null,
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: map['lastMessageTime'] is Timestamp ? (map['lastMessageTime'] as Timestamp).toDate() : null,
    );
  }

  /// Convert Firestore DocumentSnapshot to UserModel
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?; // Handle null case

    if (data == null) {
      return UserModel(
        uid: doc.id,
        firstName: '',
        email: '',
        phone: '',
        photoURL: '',
      );
    }

    return UserModel(
      uid: doc.id,
      firstName: data['firstName'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      photoURL: data['photoURL'] ?? '',
      createdAt: data['createdAt'] is Timestamp ? (data['createdAt'] as Timestamp).toDate() : null,
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime: data['lastMessageTime'] is Timestamp ? (data['lastMessageTime'] as Timestamp).toDate() : null,
    );
  }
}
