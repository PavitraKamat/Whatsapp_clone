class MessageModel {
  final String message;
  final bool isSentByUser;
  final String time;

  MessageModel(
      {required this.message, required this.isSentByUser, required this.time});
}
