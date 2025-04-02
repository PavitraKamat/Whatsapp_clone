import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wtsp_clone/fireBaseController/onetoone_chat_provider.dart';

class ImagePreviewScreen extends StatelessWidget {
 final String senderId;
  final String receiverId;
  final String imagePath;
  final FireBaseOnetoonechatProvider chatProvider;

 const ImagePreviewScreen({
    Key? key,
    required this.senderId,
    required this.receiverId,
    required this.imagePath,
    required this.chatProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.file(
                File(imagePath),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.white, size: 28),
                  onPressed: () {
                    // Add edit functionality (optional)
                  },
                ),
                FloatingActionButton(
                  backgroundColor: Colors.teal,
                  child: Icon(Icons.send, color: Colors.white),
                  onPressed: () async {
                    await chatProvider.sendImageMessage(senderId, receiverId, imagePath);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
