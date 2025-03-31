import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String content;
  final String userId; // Sender's user ID
  final DateTime timestamp;
  final bool isRead;

  MessageModel({
    required this.id,
    required this.content,
    required this.userId,
    required this.timestamp,
    this.isRead = false,
  });

  factory MessageModel.fromMap(String id,Map<String, dynamic> map) {
    return MessageModel(
      id: id,
      content: map['content']??'',
      userId: map['userId']?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      isRead: map['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'userId': userId,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
    };
  }
}

// class MessageModel {
//   String messageId; 
//   String chatId; 
//   String senderId; 
//   String receiverId;
//   String messageType; 
//   String messageContent; 
//   DateTime timestamp; 
//   bool isRead;
//   bool isDelivered;
//   List<String> seenBy; 
//   bool isDeleted; 
  
//   MessageModel({
//     required this.messageId,
//     required this.chatId,
//     required this.senderId,
//     required this.receiverId,
//     required this.messageType,
//     required this.messageContent,
//     required this.timestamp,
//     required this.isRead,
//     required this.isDelivered,
//     required this.seenBy,
//     required this.isDeleted,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       "messageId": messageId,
//       "chatId": chatId,
//       "senderId": senderId,
//       "receiverId" :receiverId,
//       "messageType": messageType,
//       "messageContent": messageContent,
//       "timestamp": timestamp.toIso8601String(),
//       "isRead":isRead,
//       "isDelivered":isDelivered,
//       "seenBy": seenBy,
//       "isDeleted": isDeleted,
//     };
//   }

//   factory MessageModel.fromMap(String id,Map<String, dynamic> map) {
//     return MessageModel(
//       messageId:id,
//       chatId: map["chatId"],
//       senderId: map["senderId"],
//       receiverId: map["receiverId"],
//       messageType: map["messageType"],
//       messageContent: map["messageContent"],
//       timestamp: DateTime.parse(map["timestamp"]),
//       isRead: map["isRead"],
//       isDelivered: map["isDelivered"],
//       seenBy: List<String>.from(map["seenBy"]),
//       isDeleted: map["isDeleted"],
//     );
//   }
// }



