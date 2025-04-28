import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/fireBaseController/onetoone_chat_provider.dart';
import 'package:wtsp_clone/fireBaseview/components/messageBubble_component/audio_message_bubble.dart';
import 'package:wtsp_clone/fireBaseview/components/messageBubble_component/deleted_message_ubble.dart';
import 'package:wtsp_clone/fireBaseview/components/messageBubble_component/image_message_bubble.dart';
import 'package:wtsp_clone/fireBaseview/components/messageBubble_component/text_message_bubble.dart';
import '../../../fireBasemodel/models/msg_model.dart';

  class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isSentByMe;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isSentByMe,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FireBaseOnetoonechatProvider>(context);
    final isSelected = provider.selectedMessageIds.contains(message.messageId);

    return GestureDetector(
      onLongPress: () {
        provider.toggleSelectionMode(true);
        provider.toggleMessageSelection(message.messageId);
      },
      onTap: () {
        if (provider.isSelectionMode) {
          provider.toggleMessageSelection(message.messageId);
        }
      },
      child: Container(
        color: isSelected
            ? const Color.fromARGB(255, 169, 230, 174).withAlpha(100)
            : Colors.transparent,
        child: Align(
          alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: _buildMessageType(message),
        ),
      ),
    );
  }

  Widget _buildMessageType(MessageModel msg) {
    if (msg.isDeletedForEveryone) {
      return DeletedMessageBubble(
        isSentByUser: isSentByMe,
      );
    }

    switch (msg.messageType) {
      case MessageType.text:
        return TextMessageBubble(
          message: msg,
          isSentByUser: isSentByMe,
        );
      case MessageType.image:
        return ImageMessageBubble(
          message: msg,
          isSentByUser: isSentByMe,
        );
      case MessageType.audio:
        return AudioMessageBubble(
          message: msg,
          isSentByUser: isSentByMe,
        );
        //throw UnimplementedError();
      case MessageType.voice:
      //throw UnimplementedError();
      case MessageType.video:
        throw UnimplementedError();
    }
  }
}


  