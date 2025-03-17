import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? uid;
  final String firstName;
  final String email;
  final String phone;
  final String photoURL;
  final DateTime? createdAt;

  UserModel({
    required this.uid,
    required this.firstName,
    required this.email,
    required this.phone,
    required this.photoURL,
    this.createdAt,
  });

  // Convert UserModel to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'email': email,
      'phone': phone,
      'photoURL': photoURL,
      'createdAt': createdAt ?? DateTime.now(),
    };
  }

  // Create UserModel from Firestore data
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      firstName: map['firstName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      photoURL: map['photoURL'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
