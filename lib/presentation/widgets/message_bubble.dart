import 'package:flutter/material.dart';
import 'package:wtsp_clone/data/models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;

  const MessageBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSentByUser = message.isSentByUser;
    double maxWidth = MediaQuery.of(context).size.width * 0.75;

    return Align(
      alignment: isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Get text size dynamically
          TextPainter textPainter = TextPainter(
            text: TextSpan(
              text: message.message,
              style: TextStyle(fontSize: 16),
            ),
            maxLines: null,
            textDirection: TextDirection.ltr,
          )..layout(maxWidth: maxWidth); // Adjust considering padding

          double textWidth =
              textPainter.width + 80; // Extra padding for timestamp
          double containerWidth = textWidth > maxWidth ? maxWidth : textWidth;

          return Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: EdgeInsets.all(12),
            width: containerWidth,
            decoration: BoxDecoration(
              color: isSentByUser
                  ? const Color.fromARGB(255, 169, 230, 174)
                  : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: isSentByUser ? Radius.circular(10) : Radius.zero,
                bottomRight: isSentByUser ? Radius.zero : Radius.circular(10),
              ),
            ),
            child: Stack(
              children: [
                Padding(padding: EdgeInsets.only(right: 50)),
                Text(
                  message.message,
                  style: TextStyle(fontSize: 16),
                ),
                //SizedBox(height: 5),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Text(
                    message.time,
                    style: TextStyle(fontSize: 10, color: Colors.black54),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
