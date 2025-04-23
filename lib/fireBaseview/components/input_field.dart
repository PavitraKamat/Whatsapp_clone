import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:wtsp_clone/fireBaseController/onetoone_chat_provider.dart';
import 'package:wtsp_clone/fireBaseview/components/attachment_bottom_sheet.dart';

class MessageInputField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final String senderId;
  final String receiverId;

  const MessageInputField({
    Key? key,
    required this.controller,
    required this.onSend,
    required this.senderId,
    required this.receiverId,
  }) : super(key: key);

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  bool isTyping = false;
  Offset _initialDragOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<FireBaseOnetoonechatProvider>(context);
    final isRecording = chatProvider.isRecording;
    final recordDuration = chatProvider.recordDuration;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0, left: 10, right: 10),
      child: Row(
        children: [
          Expanded(
            child: isRecording
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 250, 250, 250),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.mic, color: Colors.red),
                        SizedBox(width: 8),
                        Text(_formatDuration(recordDuration)),
                        Spacer(),
                        Text("Slide left to cancel",
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  )
                : _buildTextInput(),
          ),
          SizedBox(width: 5),
          _buildMicButton(chatProvider),
        ],
      ),
    );
  }

  Widget _buildTextInput() {
    return Card(
      elevation: 5,
      color: const Color.fromARGB(255, 250, 250, 250),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: TextFormField(
          controller: widget.controller,
          maxLines: null,
          onChanged: (text) => setState(() => isTyping = text.isNotEmpty),
          decoration: InputDecoration(
            hintText: "Type a message",
            border: InputBorder.none,
            prefixIcon: Icon(Icons.emoji_emotions),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (_) => AttachmentBottomSheet(
                        senderId: widget.senderId,
                        receiverId: widget.receiverId,
                      ),
                    );
                  },
                  icon: Icon(Icons.attach_file),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.camera_alt),
                ),
              ],
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
    );
  }

  Widget _buildMicButton(FireBaseOnetoonechatProvider provider) {
    return GestureDetector(
      onLongPressStart: (_) => provider.startRecording(),
      onLongPressMoveUpdate: (details) {
        if (_initialDragOffset == Offset.zero) {
          _initialDragOffset = details.globalPosition;
        }

        final dx = details.globalPosition.dx - _initialDragOffset.dx;

        if (dx < -80) {
          provider.cancelRecording();
          _initialDragOffset = Offset.zero;
        }
      },
      onLongPressEnd: (_) {
        if (provider.isRecording) {
          provider.stopRecordingAndSend(widget.senderId, widget.receiverId);
          _initialDragOffset = Offset.zero;
        }
      },
      child: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.teal,
        child: isTyping
            ? IconButton(
                icon: Icon(Icons.send, color: Colors.white),
                onPressed: () {
                  widget.onSend();
                  widget.controller.clear();
                  setState(() => isTyping = false);
                },
              )
            : Icon(Icons.mic, color: Colors.white),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }
}
