import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wtsp_clone/controller/chat_controller.dart';
import 'package:wtsp_clone/data/models/contact_model.dart';
import 'package:wtsp_clone/data/models/message_model.dart';
import 'package:wtsp_clone/presentation/widgets/message_bubble.dart';
import 'package:wtsp_clone/presentation/widgets/input_field.dart';
import 'package:wtsp_clone/presentation/widgets/chat_app_bar.dart';
import 'package:wtsp_clone/presentation/widgets/type_indicator.dart';

class IndividualPage extends StatefulWidget {
  final ContactModel contact;

  const IndividualPage({super.key, required this.contact});

  @override
  _IndividualPageState createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage> {
  final TextEditingController _messageController = TextEditingController();
  List<MessageModel> messages = [];
  bool isTyping = false;
  final ChatController _chatController = ChatController();
  bool isReceiverTyping = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _loadMessages();
      widget.contact.lastSeen = "Last seen at ${_getCurrentTime()}";
    });

    _messageController.addListener(() {
      setState(() {
        isTyping = _messageController.text.isNotEmpty;
      });
    });
    //_simulateReceiverTyping();
  }

  Future<void> _loadMessages() async {
    await _chatController.loadMessages(widget.contact.id);
    setState(() {
      messages = List.from(_chatController.messages);
    });
  }

  void _simulateReceiverTyping() {
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isReceiverTyping = true;
        });

        Future.delayed(Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              isReceiverTyping = false;
            });
          }
        });
      }
    });
  }

  void _receiveMessage(String text) {
    MessageModel receivedMessage = MessageModel(
      contactId: widget.contact.id,
      message: text,
      time: _getCurrentTime(),
      isSentByUser: false,
    );

    setState(() {
      messages.add(receivedMessage);
    });

    _chatController.saveMessage(receivedMessage, widget.contact.id);
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        widget.contact.lastSeen = "online";
      });

      _chatController.sendMessage(
          _messageController.text.trim(), _updateMessages, widget.contact.id);

      _messageController.clear();

      Future.delayed(Duration(seconds: 7), () {
        if (mounted) {
          setState(() {
            widget.contact.lastSeen = "Last seen at ${_getCurrentTime()}";
          });
        }
      });

      _simulateReceiverTyping();
    }
  }

  void _updateMessages(List<MessageModel> updatedMessages) {
    setState(() {
      messages = updatedMessages;
    });
  }

  String _getCurrentTime() {
    return DateFormat('hh:mm a').format(DateTime.now());
  }

  @override
  void dispose() {
    widget.contact.lastSeen = "Last seen at ${_getCurrentTime()}";
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/images/whatsapp_background.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: ChatAppBar(contact: widget.contact),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  itemCount: messages.length + (isReceiverTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (isReceiverTyping && index == messages.length) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: TypeIndicator(),
                        ),
                      );
                    }
                    return MessageBubble(message: messages[index]);
                  },
                ),
              ),
              MessageInputField(
                controller: _messageController,
                onSend: _sendMessage,
                isTyping: isTyping,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
