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
      //child: messageLayout(maxWidth, isSentByMe, isRead),
      child: message.messageType == MessageType.image
          ? imageMessageBubble(message, maxWidth, isSentByMe, isRead)
          : messageLayout(maxWidth, isSentByMe, isRead),
    );
    //);
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
              message.messageContent,
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
                messageStatusIcon(message),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget imageMessageBubble(
      MessageModel message, double maxWidth, bool isSentByUser, bool isRead) {
    if (message.mediaUrl == null || message.mediaUrl!.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          "Image not available",
          style: TextStyle(color: Colors.white),
        ),
      );
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      constraints: BoxConstraints(maxWidth: maxWidth),
      decoration: BoxDecoration(
        color: isSentByUser
            ? const Color.fromARGB(255, 169, 230, 174) // Sent (Greenish)
            : Colors.white, // Received (White)
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Image with rounded corners
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              message.mediaUrl!,
              width: 250,
              height: 250,
              fit: BoxFit.cover,
            ),
          ),

          /// **Optional Caption Text**
          // if (message.text.isNotEmpty)
          //   Container(
          //     margin: const EdgeInsets.only(left: 8, right: 8, top: 3),
          //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          //     decoration: BoxDecoration(
          //       color: isSentByUser ? const Color(0xFF005D4B) : Colors.white,
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //     child: Text(
          //       message.text,
          //       style: TextStyle(
          //         color: isSentByUser ? Colors.white : Colors.black87,
          //         fontSize: 14,
          //       ),
          //     ),
          //   ),
          /// Timestamp & Read Status (Ensuring uniform padding)
          Padding(
            padding: const EdgeInsets.only(right: 6, bottom: 2, top: 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat.jm().format(message.timestamp),
                  style: const TextStyle(fontSize: 10, color: Colors.black54),
                ),
                if (isSentByUser) ...[
                  const SizedBox(width: 5),
                  messageStatusIcon(message),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget messageStatusIcon(MessageModel message) {
    if (message.isRead) {
      return Icon(Icons.done_all, color: Colors.blue, size: 12);
    } else if (message.isDelivered) {
      return Icon(Icons.done_all, color: Colors.grey, size: 12);
    } else {
      return Icon(Icons.done, color: Colors.grey, size: 12);
    }
  }
}
