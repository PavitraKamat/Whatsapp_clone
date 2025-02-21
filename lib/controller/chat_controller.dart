import 'dart:async';
import 'package:intl/intl.dart';
import 'package:wtsp_clone/data/models/message_model.dart';

class ChatController {
  List<MessageModel> messages = [];

  void sendMessage(
      String message, Function(List<MessageModel>) updateMessages) {
    if (message.isNotEmpty) {
      messages.add(MessageModel(
          message: message, isSentByUser: true, time: _getCurrentTime()));

      updateMessages(List.from(messages));

      // Simulating received message after delay
      Future.delayed(Duration(seconds: 3), () {
        messages.add(MessageModel(
            message: message, isSentByUser: false, time: _getCurrentTime()));
        updateMessages(List.from(messages));
      });
    }
  }

  String _getCurrentTime() {
    return DateFormat('hh:mm a').format(DateTime.now());
  }
}
