class MessageModel {
  final int? id;
  final String contactId;
  final String message;
  final bool isSentByUser;
  final String time;
  final bool isRead;

  MessageModel({
    this.id,
    required this.contactId,
    required this.message,
    required this.isSentByUser,
    required this.time,
    this.isRead = false,
  });

  // Convert MessageModel to a Map for database storage
  Map<String, dynamic> toMap(String contactId) {
    return {
      'contactId': contactId,
      'message': message,
      'isSentByUser': isSentByUser ? 1 : 0,
      'time': time,
    };
  }

  // Create a MessageModel object from a Map
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'],
      contactId: map['contactId'],
      message: map['message'],
      isSentByUser: map['isSentByUser'] == 1,
      time: map['time'],
    );
  }
}
