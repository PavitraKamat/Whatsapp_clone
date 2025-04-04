import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/fireBaseController/onetoone_chat_provider.dart';
import 'package:wtsp_clone/fireBasemodel/models/msg_model.dart';

class MessageBubble extends StatefulWidget {
  final MessageModel message;
  final bool isSentByMe;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isSentByMe,
  }) : super(key: key);

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  ValueNotifier<bool> isImageLoaded = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    bool isRead = widget.message.isRead;
    double maxWidth = MediaQuery.of(context).size.width * 0.75;
    final provider = Provider.of<FireBaseOnetoonechatProvider>(context);
    final isSelected =
        provider.selectedMessageIds.contains(widget.message.messageId);
    // return Align(
    //   alignment: widget.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
    //   //child: messageLayout(maxWidth, isSentByMe, isRead),
    //   child: widget.message.messageType == MessageType.image
    //       ? imageMessageBubble(widget.message, maxWidth, widget.isSentByMe, isRead)
    //       : messageLayout(maxWidth, widget.isSentByMe, isRead),
    // );;

    return GestureDetector(
      onLongPress: () {
        provider.toggleSelectionMode(true);
        provider.toggleMessageSelection(widget.message.messageId);
      },
      onTap: () {
        if (provider.isSelectionMode) {
          provider.toggleMessageSelection(widget.message.messageId);
        }
      },
      child: Container(
        color: isSelected
            ? const Color.fromARGB(255, 169, 230, 174).withOpacity(0.5)
            : Colors.transparent,
        child: Align(
          alignment:
              widget.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: widget.message.messageType == MessageType.image
              ? imageMessageBubble(
                  widget.message, maxWidth, widget.isSentByMe, isRead)
              : messageLayout(maxWidth, widget.isSentByMe, isRead),
        ),
      ),
    );
  }

  //);
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
          bottomLeft:
              widget.isSentByMe ? const Radius.circular(10) : Radius.zero,
          bottomRight:
              widget.isSentByMe ? Radius.zero : const Radius.circular(10),
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
              widget.message.messageContent,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(width: 5),
          Row(
            children: [
              Text(
                DateFormat.jm().format(widget.message.timestamp),
                style: const TextStyle(fontSize: 10, color: Colors.black54),
              ),
              if (isSentByUser) ...[
                const SizedBox(width: 5),
                messageStatusIcon(widget.message),
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
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background placeholder with transparent grey color
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color:
                        Colors.grey.withOpacity(0.3), // Semi-transparent grey
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                // Image Network with loading indicator
                Image.network(
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
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child:
                        Icon(Icons.broken_image, size: 50, color: Colors.red),
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
                color:
                    Colors.black.withOpacity(0.5), // Semi-transparent overlay
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
                    messageStatusIcon(message),
                  ],
                ],
              ),
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


// GestureDetector(
//   onLongPress: () {
//     isSelectionMode.value = true;
//     selectedMessageIds.value = [widget.message.id]; // start selection
//   },
//   child: Container(
//     color: selectedMessageIds.value.contains(widget.message.id)
//         ? Colors.blue.shade100
//         : Colors.transparent,
//     child: ... // Your message bubble here
//   ),
// )