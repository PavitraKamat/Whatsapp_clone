import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wtsp_clone/controller/chat_controller.dart';
import 'package:wtsp_clone/data/models/message_model.dart';

class OnetoonechatProvider extends ChangeNotifier {
  final ChatController _chatController;
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

  OnetoonechatProvider(
      {required this.contactId, required ChatController chatController})
      : _chatController = chatController {
    _lastSeen = "Last seen at ${_getCurrentTime()}";
    _loadMessages();

    messageController.addListener(() {
      _isTyping = messageController.text.isNotEmpty;
      notifyListeners();
    });
  }

  Future<void> _loadMessages() async {
    await _chatController.loadMessages(contactId);
    _messages = List.from(_chatController.messages);
    await Future.delayed(Duration(milliseconds: 500));
    await _updateLastSeenFromDatabase();
    notifyListeners();
  }

  Future<void> _updateLastSeenFromDatabase() async {
    MessageModel? lastMessage =
        await _chatController.getLastReceivedMessage(contactId);
    print(
        "Fetched last message for $contactId: ${lastMessage?.message} at ${lastMessage?.time}");
    if (lastMessage != null) {
      _lastSeen = "Last seen at ${lastMessage.time}";
      notifyListeners();
      //print("Last seen updated from database: $_lastSeen");
    }
  }

  void sendMessage(String text) {
    if (text.trim().isNotEmpty) {
      _lastSeen = "online";
      print('$_lastSeen');
      notifyListeners();

      _chatController.sendMessage(text.trim(), _updateMessages, contactId);
      messageController.clear();

      Future.delayed(Duration(seconds: 7), () {
        _lastSeen = "Last seen at ${_getCurrentTime()}";
        print('$_lastSeen');
        notifyListeners();
      });

      _simulateReceiverTyping();
    }
  }

  void receiveMessage(String text) {
    MessageModel receivedMessage = MessageModel(
      contactId: contactId,
      message: text,
      time: _getCurrentTime(),
      isSentByUser: false,
    );

    _messages.add(receivedMessage);
    _chatController.saveMessage(receivedMessage, contactId);
    _lastSeen = "Last seen at ${receivedMessage.time}";
    notifyListeners();
    print('$_lastSeen');
  }

  void _simulateReceiverTyping() {
    //Future.delayed(Duration(seconds: 2), () {
    _isReceiverTyping = true;
    notifyListeners();
    // });

    Future.delayed(Duration(seconds: 3), () {
      _isReceiverTyping = false;
      notifyListeners();
    });
  }

  void _updateMessages(List<MessageModel> updatedMessages) {
    _messages = updatedMessages;
    notifyListeners();
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
