import 'dart:async';
import 'package:wtsp_clone/data/models/message_model.dart';

class ChatController {
  List<MessageModel> messages = [];

  void sendMessage(
      String message, Function(List<MessageModel>) updateMessages) {
    if (message.isNotEmpty) {
      messages.add(MessageModel(message: message, isSentByUser: true));

      updateMessages(List.from(messages));

      // Simulating received message after delay
      Future.delayed(Duration(seconds: 3), () {
        messages.add(MessageModel(message: message, isSentByUser: false));
        updateMessages(List.from(messages));
      });
    }
  }
}
