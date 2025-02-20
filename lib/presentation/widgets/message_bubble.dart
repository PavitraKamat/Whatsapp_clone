import 'package:flutter/material.dart';
import 'package:wtsp_clone/data/models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;

  const MessageBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSentByUser = message.isSentByUser;
    return Align(
      alignment: isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSentByUser ? Colors.teal : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: isSentByUser ? Radius.circular(10) : Radius.zero,
            bottomRight: isSentByUser ? Radius.zero : Radius.circular(10),
          ),
        ),
        child: Text(
          message.message,
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
    );
  }
}
