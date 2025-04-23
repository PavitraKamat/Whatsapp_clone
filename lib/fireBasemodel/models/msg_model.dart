import 'package:cloud_firestore/cloud_firestore.dart';
class MessageModel {
  String messageId;
  String chatId;
  String senderId;
  String receiverId;
  MessageType messageType;
  String messageContent;
  String? mediaUrl;
  DateTime timestamp;
  bool isRead;
  bool isDelivered;
  List<String> seenBy;
  List<String> deletedFor;
  bool isDeletedForEveryone;
  int? audioDuration; // in seconds
  bool isPlayed;
  bool isUploading;

  MessageModel({
    required this.messageId,
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.messageType,
    required this.messageContent,
    this.mediaUrl,
    required this.timestamp,
    required this.isRead,
    required this.isDelivered,
    required this.seenBy,
    required this.deletedFor,
    required this.isDeletedForEveryone,
    required this.audioDuration,
    required this.isPlayed,
    required this.isUploading,
  });

  /// Convert `MessageModel` to a `Map<String, dynamic>` for Firestore
  Map<String, dynamic> toMap() {
    return {
      "messageId": messageId,
      "chatId": chatId,
      "senderId": senderId,
      "receiverId": receiverId,
      "messageType": messageType.name,
      "messageContent": messageContent,
      "mediaUrl": mediaUrl,
      "timestamp": Timestamp is DateTime
          ? Timestamp.fromDate(timestamp)
          : timestamp.toIso8601String(),
      "isRead": isRead,
      "isDelivered": isDelivered,
      "seenBy": seenBy,
      "deletedFor": deletedFor,
      "isDeletedForEveryone": isDeletedForEveryone,
      "audioDuration": audioDuration,
      "isPlayed": isPlayed,
      "isUploading":isUploading,
    };
  }

  /// Factory method to create a `MessageModel` from Firestore Map
  factory MessageModel.fromMap(String id, Map<String, dynamic> map) {
    return MessageModel(
      messageId: id,
      chatId: map["chatId"],
      senderId: map["senderId"],
      receiverId: map["receiverId"],
      messageType: (map["messageType"] as String).toMessageType(),
      messageContent: map["messageContent"],
      mediaUrl: map["mediaUrl"],
      timestamp: map["timestamp"] is Timestamp
          ? (map["timestamp"] as Timestamp).toDate()
          : DateTime.parse(map["timestamp"]),
      isRead: map["isRead"] ?? false,
      isDelivered: map["isDelivered"] ?? false,
      seenBy: List<String>.from(map["seenBy"] ?? []),
      deletedFor: List<String>.from(map['deletedFor'] ?? []),
      isDeletedForEveryone: map["isDeletedForEveryone"] ?? false,
      audioDuration: map["audioDuration"] ?? 0,
      isPlayed: map["isPlayed"] ?? false,
      isUploading : map["isUploading"] ?? false,
    );
  }
}

//Enum for Message Types
enum MessageType {
  text,
  image,
  voice,
  audio,
  video,
}

// Extension to Convert String to `MessageType` Enum
extension MessageTypeExtension on String {
  MessageType toMessageType() {
    return MessageType.values.firstWhere(
      (e) => e.name == this,
      orElse: () => MessageType.text,
    );
  }
}
