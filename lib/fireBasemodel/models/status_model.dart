import 'package:cloud_firestore/cloud_firestore.dart';
class StatusModel {
  final String statusId;
  final String userId;
  final String username;
  final StatusType statusType;
  final String? mediaUrl;
  final String? textContent;
  final String? color;
  final DateTime? timestamp;
  final List<String> viewedBy;

  StatusModel({
    required this.statusId,
    required this.userId,
    required this.username,
    required this.statusType,
    this.mediaUrl,
    this.textContent,
    this.color,
    required this.timestamp,
    required this.viewedBy,
  });
  factory StatusModel.fromMap(Map<String, dynamic> map) {
  return StatusModel(
    statusId: map['statusId'] ?? '',
    userId: map['userId'] ?? '',
    username: map['username'] ?? 'User',
    statusType: map['statusType'] != null
        ? (map['statusType'] as String).toStatusType()  // Fix lowercase 's'
        : StatusType.text,
    mediaUrl: map['mediaUrl'],
    textContent: map['textContent'],
    color: map['color'],
    timestamp: map['timestamp'] is Timestamp
        ? (map['timestamp'] as Timestamp).toDate()
        : DateTime.now(),
    viewedBy: List<String>.from(map['viewedBy'] ?? []),
  );
}
  Map<String, dynamic> toMap() {
    return {
      'statusId': statusId,
      'userId': userId,
      'username': username,
      'statusType': statusType.name,
      'mediaUrl': mediaUrl,
      'textContent': textContent,
      'color': color,
      'timestamp': timestamp != null
          ? Timestamp.fromDate(timestamp!)
          : FieldValue.serverTimestamp(),
      'viewedBy': viewedBy,
    };
  }
}

enum StatusType { text, image }

extension StatusTypeExtension on String {
  StatusType toStatusType() {
    return StatusType.values.firstWhere(
      (e) => e.name == this,
      orElse: () => StatusType.text,
    );
  }
}

  // factory StatusModel.fromMap(Map<String, dynamic> map) {
  //   return StatusModel(
  //     statusId: map['statusId'] ?? '',
  //     userId: map['userId'] ?? '',
  //     username: map['username'] ?? 'User',
  //     statusType: (map['statusType'] as String).toStatusType(),
  //     mediaUrl: map['mediaUrl'] as String?,
  //     textContent: map['textContent'],
  //     color: map['color'] as String?,
  //     timestamp: map['timestamp'] is Timestamp
  //         ? (map['timestamp'] as Timestamp).toDate()
  //         : null,
  //     viewedBy: List<String>.from(map['viewedBy'] ?? []),
  //   );
  // }

