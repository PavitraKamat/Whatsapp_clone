import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String content;
  final String userId;
  final bool isFromCurrentUser;
  final DateTime timestamp;
  final bool isRead;

  MessageModel({
    required this.id,
    required this.content,
    required this.userId,
    required this.isFromCurrentUser,
    required this.timestamp,
    this.isRead = false,
  });

  // Convert the object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'userId': userId,
      'isFromCurrentUser': isFromCurrentUser,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  // Create an object from Firestore DocumentSnapshot
  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MessageModel(
      id: doc.id,
      content: data['content'] ?? '',
      userId: data['userId'] ?? '',
      isFromCurrentUser: data['isFromCurrentUser'] ?? false,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
  // String get formattedTime {
  //   return DateFormat('h:mm a').format(timestamp.toDate());
  // }
}
