import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String user1;
  final String user2;
  final String lastMessage;
  final DateTime lastMessageTime;

  ChatModel({
    required this.user1,
    required this.user2,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  // Convert the object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'user1': user1,
      'user2': user2,
      'lastMessage': lastMessage,
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
    };
  }

  // Create an object from Firestore DocumentSnapshot
  factory ChatModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ChatModel(
      user1: data['user1'] ?? '',
      user2: data['user2'] ?? '',
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime: (data['lastMessageTime'] as Timestamp).toDate(),
    );
  }
}
