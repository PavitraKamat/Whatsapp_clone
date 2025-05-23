import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:wtsp_clone/fireBaseController/onetoone_chat_provider.dart';
import 'package:wtsp_clone/fireBaseview/components/attachment_bottom_sheet.dart';

class MessageInputField extends StatelessWidget {
  final VoidCallback onSend;
  final String senderId;
  final String receiverId;

  const MessageInputField({
    super.key,
    required this.onSend,
    required this.senderId,
    required this.receiverId,
  });

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<FireBaseOnetoonechatProvider>(context);
    final isRecording = chatProvider.isRecording;
    final recordDuration = chatProvider.recordDuration;
    final isTyping = chatProvider.isTyping;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0, left: 10, right: 10),
      child: Row(
        children: [
          Expanded(
            child: isRecording
                ? _buildRecordingUI(recordDuration)
                : _buildTextInput(context, chatProvider),
          ),
          const SizedBox(width: 5),
          _buildMicButton(chatProvider, isTyping),
        ],
      ),
    );
  }

  Widget _buildRecordingUI(int recordDuration) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 250, 250, 250),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          const Icon(Icons.mic, color: Colors.red),
          const SizedBox(width: 8),
          Text(_formatDuration(recordDuration)),
          const Spacer(),
          const Text("Slide left to cancel",
              style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildTextInput(BuildContext context, FireBaseOnetoonechatProvider chatProvider) {
    return Card(
      elevation: 5,
      color: const Color.fromARGB(255, 250, 250, 250),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TextFormField(
          controller: chatProvider.messageController,
          maxLines: null,
          onChanged: (text) => chatProvider.upDateTypingStatus(text),
          decoration: InputDecoration(
            hintText: "Type a message",
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.emoji_emotions),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (_) => AttachmentBottomSheet(
                        senderId: senderId,
                        receiverId: receiverId,
                      ),
                    );
                  },
                  icon: const Icon(Icons.attach_file),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.camera_alt),
                ),
              ],
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
    );
  }

  Widget _buildMicButton(FireBaseOnetoonechatProvider provider, bool isTyping) {
    return GestureDetector(
      onLongPressStart: (details) {
        provider.setInitialDragOffset(details.globalPosition);
        provider.startRecording();
      },
      onLongPressMoveUpdate: (details) {
        final dx = details.globalPosition.dx - provider.initialDragOffset.dx;
        if (dx < -80) {
          provider.cancelRecording();
          provider.resetInitialDragOffset();
        }
      },
      onLongPressEnd: (_) {
        if (provider.isRecording) {
          provider.stopRecordingAndSend(senderId, receiverId);
          provider.resetInitialDragOffset();
        }
      },
      child: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.teal,
        child: isTyping
            ? IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () {
                  onSend();
                  provider.messageController.clear();
                  provider.resetTyping();
                },
              )
            : const Icon(Icons.mic, color: Colors.white),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }
}
