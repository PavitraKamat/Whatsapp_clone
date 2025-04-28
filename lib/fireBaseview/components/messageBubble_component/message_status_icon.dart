import 'package:flutter/material.dart';
import 'package:wtsp_clone/fireBasemodel/models/msg_model.dart';

class MessageStatusIcon extends StatelessWidget{
  final MessageModel message;

  const MessageStatusIcon({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.isRead) {
      return Icon(Icons.done_all, color: Colors.blue, size: 12);
    } else if (message.isDelivered) {
      return Icon(Icons.done_all, color: Colors.grey, size: 12);
    } else {
      return Icon(Icons.done, color: Colors.grey, size: 12);
    }
  }
 }

