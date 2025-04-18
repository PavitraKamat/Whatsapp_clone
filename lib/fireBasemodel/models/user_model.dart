// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class UserModel {
//   final String uid;
//   final String firstName;
//   final String email;
//   final String phone;
//   final String photoURL;
//   final String aboutInfo;
//   final DateTime? createdAt;
//   final String? lastMessage;
//   final DateTime? lastMessageTime;

//   UserModel({
//     required this.uid,
//     required this.firstName,
//     required this.email,
//     required this.phone,
//     required this.photoURL,
//     this.aboutInfo = "Hey there! I'm using WhatsApp",
//     this.createdAt,
//     this.lastMessage,
//     this.lastMessageTime,
//   });

//   /// Convert UserModel to Firestore Map
//   Map<String, dynamic> toMap() {
//     return {
//       'uid': uid,
//       'firstName': firstName,
//       'email': email,
//       'phone': phone,
//       'photoURL': photoURL,
//       'aboutInfo': aboutInfo,
//       'createdAt': createdAt != null
//           ? Timestamp.fromDate(createdAt!)
//           : FieldValue.serverTimestamp(),
//       'lastMessage': lastMessage,
//       'lastMessageTime':
//           lastMessageTime != null ? Timestamp.fromDate(lastMessageTime!) : null,
//     };
//   }

//   /// Convert Firestore Map to UserModel
//   factory UserModel.fromMap(Map<String, dynamic> map) {
//     return UserModel(
//       uid: map['uid'] ?? '',
//       firstName: map['firstName'] ?? '',
//       email: map['email'] ?? '',
//       phone: map['phone'] ?? '',
//       photoURL: map['photoURL'] ?? '',
//       aboutInfo: map['aboutInfo'] ?? "Hey there! I'm using WhatsApp",
//       createdAt: map['createdAt'] is Timestamp
//           ? (map['createdAt'] as Timestamp).toDate()
//           : null,
//       lastMessage: map['lastMessage'] ?? '',
//       lastMessageTime: map['lastMessageTime'] is Timestamp
//           ? (map['lastMessageTime'] as Timestamp).toDate()
//           : null,
//     );
//   }

//   factory UserModel.fromFirestore(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>?;

//     return UserModel(
//       uid: doc.id,
//       firstName: data?['firstName'] ?? '',
//       email: data?['email'] ?? '',
//       phone: data?['phone'] ?? '',
//       photoURL: data?['photoURL'] ?? '',
//       aboutInfo: data?['aboutInfo'] ?? "Hey there! I'm using WhatsApp",
//       createdAt: data?['createdAt'] is Timestamp
//           ? (data?['createdAt'] as Timestamp).toDate()
//           : null,
//       lastMessage: data?['lastMessage'] ?? '',
//       lastMessageTime: data?['lastMessageTime'] is Timestamp
//           ? (data?['lastMessageTime'] as Timestamp).toDate()
//           : null,
//     );
//   }

//   factory UserModel.fromFirebaseUser(User firebaseUser) {
//     return UserModel(
//       uid: firebaseUser.uid,
//       firstName: firebaseUser.displayName ?? '',
//       email: firebaseUser.email ?? '',
//       phone: firebaseUser.phoneNumber ?? '',
//       photoURL: firebaseUser.photoURL ?? '',
//       aboutInfo: "Hey there! I'm using WhatsApp",
//       createdAt: DateTime.now(),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String firstName;
  final String email;
  final String phone;
  final String photoURL;
  final String aboutInfo;
  final bool isOnline;
  final DateTime? createdAt;
  final DateTime? lastSeen;

  UserModel({
    required this.uid,
    required this.firstName,
    required this.email,
    required this.phone,
    required this.photoURL,
    this.aboutInfo = "Hey there! I'm using WhatsApp",
    this.isOnline = false,
    this.createdAt,
    this.lastSeen,
  });

  /// Convert UserModel to Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'email': email,
      'phone': phone,
      'photoURL': photoURL,
      'aboutInfo': aboutInfo,
      'isOnline': isOnline,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'lastSeen':
          lastSeen != null ? Timestamp.fromDate(lastSeen!) : null,
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
      aboutInfo: map['aboutInfo'] ?? "Hey there! I'm using WhatsApp",
      isOnline: map['isOnline'] ?? false,
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      lastSeen: map['lastSeen'] is Timestamp
          ? (map['lastSeen'] as Timestamp).toDate()
          : null,
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    return UserModel(
      uid: doc.id,
      firstName: data?['firstName'] ?? '',
      email: data?['email'] ?? '',
      phone: data?['phone'] ?? '',
      photoURL: data?['photoURL'] ?? '',
      aboutInfo: data?['aboutInfo'] ?? "Hey there! I'm using WhatsApp",
      isOnline: data?['isOnline'] ?? false,
      createdAt: data?['createdAt'] is Timestamp
          ? (data?['createdAt'] as Timestamp).toDate()
          : null,
      lastSeen: data?['lastSeen'] is Timestamp
          ? (data?['lastSeen'] as Timestamp).toDate()
          : null,
    );
  }

  factory UserModel.fromFirebaseUser(User firebaseUser) {
    return UserModel(
      uid: firebaseUser.uid,
      firstName: firebaseUser.displayName ?? '',
      email: firebaseUser.email ?? '',
      phone: firebaseUser.phoneNumber ?? '',
      photoURL: firebaseUser.photoURL ?? '',
      aboutInfo: "Hey there! I'm using WhatsApp",
      createdAt: DateTime.now(),
    );
  }
}
