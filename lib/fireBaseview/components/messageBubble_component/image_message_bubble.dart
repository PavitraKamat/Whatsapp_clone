import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wtsp_clone/fireBasemodel/models/msg_model.dart';
import 'package:wtsp_clone/fireBaseview/components/messageBubble_component/message_status_icon.dart';

class ImageMessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isSentByUser;

  const ImageMessageBubble({super.key, required this.message, required this.isSentByUser});

  @override
  Widget build(BuildContext context) {
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
  bool isLocalFile = message.mediaUrl!.startsWith('/');
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.75),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
    ),
    child: Stack(
      alignment: Alignment.bottomRight,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              isLocalFile
                  ? Image.file(
                      File(message.mediaUrl!),
                      width: 250,
                      height: 250,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                        child: Icon(Icons.broken_image,
                            size: 50, color: Colors.red),
                      ),
                    )
                  : Image.network(
                      message.mediaUrl!,
                      width: 250,
                      height: 250,
                      fit: BoxFit.fill,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                            color: Colors.white,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                        child: Icon(Icons.broken_image,
                            size: 50, color: Colors.red),
                      ),
                    ),
            ],
          ),
        ),
        Positioned(
          bottom: 3,
          right: 4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat.jm().format(message.timestamp),
                  style: const TextStyle(
                      fontSize: 10,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold),
                ),
                if (isSentByUser) ...[
                  const SizedBox(width: 5),
                  MessageStatusIcon(message: message),
                ],
              ],
            ),
          ),
        ),
        if (message.isUploading)
          Positioned.fill(
            child: Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    ),
  );
   
  }
}
  