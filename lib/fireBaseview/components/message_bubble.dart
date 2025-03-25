import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wtsp_clone/fireBasemodel/models/msg_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isSentByMe; 

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isSentByMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isRead = message.isRead;
    double maxWidth = MediaQuery.of(context).size.width * 0.75;

    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: messageLayout(maxWidth, isSentByMe, isRead),
    );
  }

  Widget messageLayout(double maxWidth, bool isSentByUser, bool isRead) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      constraints: BoxConstraints(maxWidth: maxWidth),
      decoration: BoxDecoration(
        color: isSentByUser
            ? const Color.fromARGB(255, 169, 230, 174)
            : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(10),
          topRight: const Radius.circular(10),
          bottomLeft: isSentByMe ? const Radius.circular(10) : Radius.zero,
          bottomRight: isSentByMe ? Radius.zero : const Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Text(
              message.content,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(width: 5),
          Row(
            children: [
              Text(
                DateFormat.jm().format(message.timestamp),
                style: const TextStyle(fontSize: 10, color: Colors.black54),
              ),
              if (isSentByUser) ...[
                const SizedBox(width: 5),
                Icon(
                  Icons.done_all,
                  size: 12,
                  color: isRead
                      ? const Color.fromARGB(255, 77, 149, 63)
                      : Colors.grey,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
