import 'package:intl/intl.dart';
import 'package:wtsp_clone/data/dataSources/wtsp_db.dart';
import 'package:wtsp_clone/data/models/message_model.dart';

class ChatController {
  List<MessageModel> messages = [];
  
  Future<void> loadMessages(String contactId) async {
    messages = await WtspDb.instance.getMessages(contactId);
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

      await WtspDb.instance.insertMessage(newMessage, contactId);
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

        await WtspDb.instance.insertMessage(receivedMessage, contactId);
        messages.add(receivedMessage);
        updateMessages(List.from(messages));
      });
    }
  }

  String _getCurrentTime() {
    return DateFormat('hh:mm a').format(DateTime.now());
  }

  Future<void> saveMessage(MessageModel message, String contactId) async {
    await WtspDb.instance.insertMessage(message, contactId);
  }

  Future<MessageModel?> getLastReceivedMessage(String contactId) async {
    return await WtspDb.instance.getLastReceivedMessage(contactId);
  }

  Future<Map<String, String>?> getLastMessage(String contactId) async {
    return await WtspDb.instance.getLastMessage(contactId);
  }
}
