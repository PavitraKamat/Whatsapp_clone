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
        actions: [
          IconButton(
            icon: const Icon(Icons.crop_rotate, size: 27),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.emoji_emotions_outlined, size: 27),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.title, size: 27),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.edit, size: 27),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Image.file(
                File(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 70,
              color: const Color.fromARGB(123, 100, 100, 100),
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical:4, horizontal:13),
              child: Row(
                children: [
                  /// Add photo icon
                  const Icon(Icons.add_photo_alternate, color: Colors.white, size: 26),

                  /// Text input field
                  Expanded(
                    child: TextFormField(
                      style: const TextStyle(color: Colors.white, fontSize: 17),
                      maxLines: 6,
                      minLines: 1,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Add Caption....",
                        hintStyle: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                  ),

                  /// Send button (now clickable)
                  GestureDetector(
                      onTap: () async {
                        await chatProvider.sendImageMessage(
                            senderId, receiverId, imagePath);
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.tealAccent[700],
                          child: const Icon(Icons.send, color: Colors.white, size: 24),
                        ),
                    )
                ],
              ),
            ),
          ),
          // Container(
          //   padding: EdgeInsets.all(10),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Row(
          //         children: [
          //           IconButton(
          //             icon: Icon(Icons.add_photo_alternate, color: Colors.white, size: 27),
          //             onPressed: () {
          //               // Add photo functionality (optional)
          //             },
          //           ),
          //           // FloatingActionButton(
          //           //   backgroundColor: Colors.teal,
          //           //   child: Icon(Icons.send, color: Colors.white,size:10,),
          //           //   onPressed: () async {
          //           //     await chatProvider.sendImageMessage(
          //           //         senderId, receiverId, imagePath);
          //           //     Navigator.pop(context);
          //           //   },
          //           // ),
                    
          //           GestureDetector(
          //             onTap: () async {
          //               await chatProvider.sendImageMessage(
          //                   senderId, receiverId, imagePath);
          //               Navigator.pop(context);
          //             },
          //             child: CircleAvatar(
          //                 radius: 27,
          //                 backgroundColor: Colors.tealAccent[700],
          //                 child: const Icon(Icons.check, color: Colors.white, size: 27),
          //               ),
          //           )
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
