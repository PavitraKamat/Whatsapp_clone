import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/fireBaseController/onetoone_chat_provider.dart';
import 'package:wtsp_clone/fireBaseview/components/image_preview_screen.dart'; // Import image_picker

class AttachmentBottomSheet extends StatelessWidget {
  final String senderId;
  final String receiverId;
  final ImagePicker _picker = ImagePicker();

  AttachmentBottomSheet(
      {super.key, required this.senderId, required this.receiverId});

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (!context.mounted) return;
    if (pickedFile != null) {
      final chatProvider =
          Provider.of<FireBaseOnetoonechatProvider>(context, listen: false);
          Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImagePreviewScreen(
            senderId: senderId,
            receiverId: receiverId,
            imagePath: pickedFile.path,
            chatProvider: chatProvider,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 278,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: EdgeInsets.all(18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.insert_drive_file, Colors.indigo,
                      "Document", context, ImageSource.gallery),
                  SizedBox(width: 40),
                  iconCreation(Icons.camera_alt, Colors.pink, "Camera", context,
                      ImageSource.camera),
                  SizedBox(width: 40),
                  iconCreation(Icons.insert_photo, Colors.purple, "Gallery",
                      context, ImageSource.gallery),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.headset, Colors.orange, "Audio", context,
                      null), // Modify as needed
                  SizedBox(width: 40),
                  iconCreation(Icons.location_pin, Colors.teal, "Location",
                      context, null), // Modify as needed
                  SizedBox(width: 40),
                  iconCreation(Icons.person, Colors.blue, "Contact", context,
                      null), // Modify as needed
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(IconData icons, Color color, String text,
      BuildContext context, ImageSource? source) {
    return InkWell(
      onTap: () {
        // If the source is provided, pick the image
        if (source != null) {
          //Navigator.pop(context);
          _pickImage(context, source);
        }
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icons,
              size: 29,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
