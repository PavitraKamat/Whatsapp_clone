import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/controller/contact_provider.dart';
import 'package:wtsp_clone/controller/navigation_service.dart';
import 'package:wtsp_clone/model/dataSources/wtsp_db.dart';
import 'package:wtsp_clone/model/models/message_model.dart';

class OnetoonechatProvider extends ChangeNotifier {
  final String contactId;
  List<MessageModel> _messages = [];
  bool _isTyping = false;
  bool _isReceiverTyping = false;
  String _lastSeen = "";

  TextEditingController messageController = TextEditingController();

  List<MessageModel> get messages => _messages;
  bool get isTyping => _isTyping;
  bool get isReceiverTyping => _isReceiverTyping;
  String get lastSeen => _lastSeen;

  OnetoonechatProvider({required this.contactId}) {
    _lastSeen = "Last seen at ${_getCurrentTime()}";
    _loadMessages();

    messageController.addListener(() {
      _isTyping = messageController.text.isNotEmpty;
      notifyListeners();
    });
  }
  Future<void> _loadMessages() async {
    _messages = await WtspDb.instance.getMessages(contactId);
    if (_messages.isNotEmpty) {
      var lastMsg = _messages.last;
      print("Last message fetched: '${lastMsg.message}' at ${lastMsg.time}");
    } else {
      print("No messages to display.");
    }
    await _updateLastSeenFromDatabase();
    notifyListeners();
  }

  Future<void> _updateLastSeenFromDatabase() async {
    MessageModel? lastMessage =
        await WtspDb.instance.getLastReceivedMessage(contactId);
    if (lastMessage != null) {
      _lastSeen = "Last seen at ${lastMessage.time}";
      notifyListeners();
      print("Last seen updated from database: $_lastSeen");
    } else {
      print("No last message found for updating last seen.");
    }
  }

  void sendMessage(String text) async {
    if (text.trim().isNotEmpty) {
      _lastSeen = "online";
      notifyListeners();
      print(
          "Sending message: '$text' to contact: $contactId at ${_getCurrentTime()}");

      MessageModel newMessage = MessageModel(
        contactId: contactId,
        message: text.trim(),
        isSentByUser: true,
        time: _getCurrentTime(),
      );

      await WtspDb.instance.insertMessage(newMessage, contactId);
      _messages.add(newMessage);
      notifyListeners();

      Future.delayed(Duration(seconds: 3), () async {
        MessageModel receivedMessage = MessageModel(
          contactId: contactId,
          message: text,
          isSentByUser: false,
          time: _getCurrentTime(),
        );

        await WtspDb.instance.insertMessage(receivedMessage, contactId);
        _messages.add(receivedMessage);
        notifyListeners();
      });

      messageController.clear();
      Future.delayed(Duration(seconds: 7), () async {
        await _updateLastSeenFromDatabase();
      });
      _simulateReceiverTyping();
    }
    final contactsProvider = Provider.of<ContactsProvider>(
        NavigationService.navigatorKey.currentContext!,
        listen: false);
    
    contactsProvider.updateLastMessage(contactId, text, _getCurrentTime());
  }

  void _simulateReceiverTyping() {
    _isReceiverTyping = true;
    notifyListeners();
    Future.delayed(Duration(seconds: 3), () {
      _isReceiverTyping = false;
      notifyListeners();
    });
  }

  String _getCurrentTime() {
    return DateFormat('hh:mm a').format(DateTime.now());
  }

  @override
  void dispose() {
    _lastSeen = "Last seen at ${_getCurrentTime()}";
    messageController.dispose();
    super.dispose();
  }
}
