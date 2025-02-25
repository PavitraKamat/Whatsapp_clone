import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wtsp_clone/presentation/screens/updates/text_status_screen.dart';
import 'package:wtsp_clone/presentation/widgets/utils.dart';

class UpdatesScreen extends StatefulWidget {
  final Function(Uint8List?) onImageSelected;
  final Function(String) onTextStatusAdded;

  const UpdatesScreen({
    super.key,
    required this.onImageSelected,
    required this.onTextStatusAdded,
  });

  @override
  _UpdatesScreenState createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends State<UpdatesScreen> {
  Uint8List? _image;
  String? _textStatus;
  List<String> statuses = [];

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
    widget.onImageSelected(img);
  }

  void _uploadTextStatus(String status) {
    setState(() {
      statuses.insert(0, status);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Updates",
          style: TextStyle(
            color: Colors.teal,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.camera_alt, color: Colors.black),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: (value) {},
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: "Settings",
                  child: Text("Settings"),
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Stack(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: _image != null
                        ? MemoryImage(_image!)
                        : AssetImage("assets/images/profile.jpg")
                            as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.teal,
                      child: Icon(Icons.add, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
              title: Text(
                "My Status",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Tap to add status update"),
              onTap: selectImage,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Recent Updates",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: AssetImage("assets/images/contact1.jpg"),
              ),
              title: Text("John Doe"),
              subtitle: Text("Just now"),
              onTap: () {},
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Viewed Updates",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: AssetImage("assets/images/contact3.jpg"),
              ),
              title: Text("Jane Smith"),
              subtitle: Text("1 hour ago"),
              onTap: () {},
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Channels",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.blue.shade300,
                backgroundImage: AssetImage("assets/images/channel1.png"),
              ),
              title: Text("Flutter Devs"),
              subtitle: Text("500K followers"),
              onTap: () {},
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "textStatus",
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TextStatusScreen(),
                ),
              );

              if (result != null && result is String) {
                setState(() {
                  _textStatus = result;
                });
                widget.onTextStatusAdded(result);
              }
            },
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.edit, color: Colors.white),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "imageStatus",
            onPressed: selectImage,
            backgroundColor: Colors.teal,
            child: Icon(Icons.camera_alt, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
