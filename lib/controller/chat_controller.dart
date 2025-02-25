import 'package:intl/intl.dart';
import 'package:wtsp_clone/data/dataSources/chat_dataBase.dart';
import 'package:wtsp_clone/data/models/message_model.dart';

class ChatController {
  List<MessageModel> messages = [];
  Future<void> loadMessages(String contactId) async {
    messages = await ChatDatabase.instance.getMessages(contactId);
  }

  void sendMessage(String message, Function(List<MessageModel>) updateMessages,
      String contactId) async {
    if (message.isNotEmpty) {
      MessageModel newMessage = MessageModel(
        contactId: contactId,
        message: message,
        isSentByUser: true,
        time: _getCurrentTime(),
      );

      await ChatDatabase.instance.insertMessage(newMessage, contactId);
      messages.add(newMessage);
      updateMessages(List.from(messages));

      // Simulate received message after delay
      Future.delayed(Duration(seconds: 3), () async {
        MessageModel receivedMessage = MessageModel(
          contactId: contactId,
          message: message,
          isSentByUser: false,
          time: _getCurrentTime(),
        );

        await ChatDatabase.instance.insertMessage(receivedMessage, contactId);
        messages.add(receivedMessage);
        updateMessages(List.from(messages));
      });
    }
  }

  String _getCurrentTime() {
    return DateFormat('hh:mm a').format(DateTime.now());
  }

  Future<void> saveMessage(MessageModel message, String contactId) async {
    await ChatDatabase.instance.insertMessage(message, contactId);
  }
}
