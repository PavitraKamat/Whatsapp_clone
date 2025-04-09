import 'package:flutter/material.dart';
import 'package:wtsp_clone/fireBaseview/components/attachment_bottom_sheet.dart';

class MessageInputField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  //final bool isTyping;
  final String senderId;
  final String receiverId;

  const MessageInputField({
    Key? key,
    required this.controller,
    required this.onSend,
    //required this.isTyping,
    required this.senderId,
    required this.receiverId,
  }) : super(key: key);

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  bool isTyping = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0, left: 10, right: 10),
      child: Row(
        children: [
          Expanded(
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  controller: widget.controller,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onChanged: (text) {
                    if (isTyping != text.isNotEmpty) {
                      setState(() {
                        isTyping = text.isNotEmpty;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Type a message",
                    border: InputBorder.none,
                    prefixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.emoji_emotions),
                      color: Colors.grey,
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (builder) => AttachmentBottomSheet(
                                        senderId: widget.senderId,
                                        receiverId: widget.receiverId,
                                      ));
                            },
                            icon: Icon(Icons.attach_file)),
                        IconButton(
                            onPressed: () {}, icon: Icon(Icons.camera_alt)),
                      ],
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 5),
          Padding(
            padding: const EdgeInsets.only(right: 5, bottom: 2),
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.teal,
              child: IconButton(
                  icon: Icon(isTyping ? Icons.send : Icons.mic,
                      color: Colors.white),
                  onPressed: () {
                    if (isTyping) {
                      widget.onSend();
                      widget.controller.clear();
                      setState(() {
                        isTyping = false;
                      });
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
