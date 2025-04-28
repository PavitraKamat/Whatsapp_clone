import 'package:flutter/material.dart';

class DeletedMessageBubble extends StatelessWidget {
  final bool isSentByUser;

  const DeletedMessageBubble({super.key, required this.isSentByUser});

  @override
  Widget build(BuildContext context) {
    String text = isSentByUser
        ? "You deleted this message"
        : "This message was deleted";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: isSentByUser
            ? const Color.fromARGB(255, 169, 230, 174)
            : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(10),
          topRight: const Radius.circular(10),
          bottomLeft: isSentByUser ? const Radius.circular(10) : Radius.zero,
          bottomRight: isSentByUser ? Radius.zero : const Radius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontStyle: FontStyle.italic,
          fontSize: 14,
          color: Colors.black54,
        ),
      ),
    );
  }
}
