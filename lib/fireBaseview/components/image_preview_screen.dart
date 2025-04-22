import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wtsp_clone/fireBaseController/onetoone_chat_provider.dart';

class ImagePreviewScreen extends StatelessWidget {
  final String senderId;
  final String receiverId;
  final String imagePath;
  final FireBaseOnetoonechatProvider chatProvider;

  const ImagePreviewScreen({
    super.key,
    required this.senderId,
    required this.receiverId,
    required this.imagePath,
    required this.chatProvider,
  });

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.crop_rotate, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon:
                const Icon(Icons.emoji_emotions_outlined, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.title, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              width: double.infinity,
              child: Hero(
                tag: 'imagePreview',
                child: Image.file(
                  File(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Caption input section
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 122, 122, 122).withOpacity(0.4),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                const Icon(Icons.add_photo_alternate, color: Colors.white70),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: textController,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    decoration: const InputDecoration(
                      hintText: "Add Caption...",
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    
                    chatProvider.sendImageMessage(senderId,receiverId,imagePath);
                  },
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.tealAccent[700],
                    child: const Icon(Icons.send, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
