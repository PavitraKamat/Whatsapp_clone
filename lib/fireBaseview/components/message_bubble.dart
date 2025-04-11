
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/fireBaseController/onetoone_chat_provider.dart';
import 'package:wtsp_clone/fireBaseview/components/audio_message_bubble.dart';
import '../../fireBasemodel/models/msg_model.dart';

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
  @override
  Widget build(BuildContext context) {
    bool isRead = widget.message.isRead;
    double maxWidth = MediaQuery.of(context).size.width * 0.75;
    final provider = Provider.of<FireBaseOnetoonechatProvider>(context);
    final isSelected =
        provider.selectedMessageIds.contains(widget.message.messageId);

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
          // child: widget.message.messageType == MessageType.image
          //     ? imageMessageBubble(
          //         widget.message, maxWidth, widget.isSentByMe, isRead)
          //     : messageLayout(maxWidth, widget.isSentByMe, isRead),
          child: _buildMessageContent(maxWidth, isRead),
        ),
      ),
    );
  }

  Widget _buildMessageContent(double maxWidth, bool isRead) {
    switch (widget.message.messageType) {
      case MessageType.image:
        return imageMessageBubble(
            widget.message, maxWidth, widget.isSentByMe, isRead);
      case MessageType.audio:
        // return audioMessageBubble(
        //     widget.message, maxWidth, widget.isSentByMe, isRead);
      return AudioMessageBubble(
        message: widget.message,
        maxWidth: maxWidth,
        isSentByUser: widget.isSentByMe,
        isRead: isRead,
      );
      default:
        return messageLayout(maxWidth, widget.isSentByMe, isRead);
    }
  }

  Widget messageLayout(double maxWidth, bool isSentByUser, bool isRead) {
    //final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    final isDeletedForEveryone = widget.message.isDeletedForEveryone;
    if (isDeletedForEveryone) {
      return deletedMessageBubble(
        isDeletedForEveryone: true,
        isSentByUser: widget.isSentByMe,
      );
    }

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
    final isDeletedForEveryone = widget.message.isDeletedForEveryone;
    if (isDeletedForEveryone) {
      return deletedMessageBubble(
        isDeletedForEveryone: true,
        isSentByUser: widget.isSentByMe,
      );
    }
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
        // color: isSentByUser
        //     ? const Color.fromARGB(255, 169, 230, 174) // Sent (Greenish)
        //     : Colors.white, // Received (White)
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
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
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

  // Widget audioMessageBubble(
  //   MessageModel message,
  //   double maxWidth,
  //   bool isSentByUser,
  //   bool isRead,
  // ) {
  //   return StatefulBuilder(
  //     builder: (context, setState) {
  //       final AudioPlayer _player = AudioPlayer();
  //       bool isPlaying = false;
  //       StreamSubscription<PlayerState>? _playerSubscription;

  //       void _togglePlayback() async {
  //         if (!isPlaying) {
  //           try {
  //             await _player.stop();
  //             await _player.setUrl(message.mediaUrl!);
  //             await _player.play();
  //             setState(() => isPlaying = true);

  //             _playerSubscription?.cancel();
  //             _playerSubscription = _player.playerStateStream.listen((state) {
  //               if (state.processingState == ProcessingState.completed) {
  //                 if (context.mounted) {
  //                   setState(() => isPlaying = false);
  //                 }
  //               }
  //             });
  //           } catch (e) {
  //             debugPrint("Error: $e");
  //           }
  //         } else {
  //           await _player.pause();
  //           setState(() => isPlaying = false);
  //         }
  //       }

  //       // Clean up audio player
  //       WidgetsBinding.instance.addPostFrameCallback((_) {
  //         ModalRoute.of(context)?.addScopedWillPopCallback(() async {
  //           await _player.dispose();
  //           return true;
  //         });
  //       });

  //       return Container(
  //         margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
  //         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
  //         constraints: BoxConstraints(maxWidth: maxWidth),
  //         decoration: BoxDecoration(
  //           color: isSentByUser
  //               ? const Color.fromARGB(255, 169, 230, 174)
  //               : const Color(0xFFE7E7E7),
  //           borderRadius: BorderRadius.only(
  //             topLeft: const Radius.circular(16),
  //             topRight: const Radius.circular(16),
  //             bottomLeft:
  //                 isSentByUser ? const Radius.circular(16) : Radius.zero,
  //             bottomRight:
  //                 isSentByUser ? Radius.zero : const Radius.circular(16),
  //           ),
  //         ),
  //         child: Row(
  //           children: [
  //             // Playback Speed (optional)
  //             Text(
  //               "1×",
  //               style: TextStyle(
  //                 color: isSentByUser ? Colors.white : Colors.black,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //             const SizedBox(width: 8),

  //             // Play/Pause Button
  //             GestureDetector(
  //               onTap: _togglePlayback,
  //               child: Icon(
  //                 isPlaying
  //                     ? Icons.pause
  //                     : Icons.play_arrow,
  //                 color: isSentByUser ? Colors.white : Colors.black87,
  //                 size: 34,
  //               ),
  //             ),
  //             const SizedBox(width: 6),

  //             // Simulated Waveform
  //             Expanded(
  //               child: Container(
  //                 height: 30,
  //                 alignment: Alignment.centerLeft,
  //                 child: ListView.builder(
  //                   scrollDirection: Axis.horizontal,
  //                   physics: const NeverScrollableScrollPhysics(),
  //                   itemCount: 20,
  //                   itemBuilder: (context, index) {
  //                     final height = (index % 5 + 1) * 6.0;
  //                     return Container(
  //                       width: 3,
  //                       height: height,
  //                       margin: const EdgeInsets.symmetric(horizontal: 1),
  //                       decoration: BoxDecoration(
  //                         color: isSentByUser ? Colors.white : Colors.black54,
  //                         borderRadius: BorderRadius.circular(2),
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(width: 6),

  //             // Time and Status
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.end,
  //               children: [
  //                 Text(
  //                   DateFormat.jm().format(message.timestamp),
  //                   style: TextStyle(
  //                     color: isSentByUser ? Colors.white70 : Colors.black54,
  //                     fontSize: 10,
  //                   ),
  //                 ),
  //                 if (isSentByUser)
  //                   Padding(
  //                     padding: const EdgeInsets.only(top: 2),
  //                     child: messageStatusIcon(message),
  //                   ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  
  Widget messageStatusIcon(MessageModel message) {
    if (message.isRead) {
      return Icon(Icons.done_all, color: Colors.blue, size: 12);
    } else if (message.isDelivered) {
      return Icon(Icons.done_all, color: Colors.grey, size: 12);
    } else {
      return Icon(Icons.done, color: Colors.grey, size: 12);
    }
  }

  Widget deletedMessageBubble(
      {required bool isDeletedForEveryone, required bool isSentByUser}) {
    String text =
        isSentByUser ? "You deleted this message" : "This message was deleted";

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
          bottomLeft:
              widget.isSentByMe ? const Radius.circular(10) : Radius.zero,
          bottomRight:
              widget.isSentByMe ? Radius.zero : const Radius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontStyle: FontStyle.italic,
          fontSize: 14,
          color: Colors.black54,
        ),
      ),
    );
  }
}
