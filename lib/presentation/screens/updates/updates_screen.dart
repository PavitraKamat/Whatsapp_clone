import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wtsp_clone/presentation/screens/updates/image_status_view.dart';
import 'package:wtsp_clone/presentation/screens/updates/status_view_screen.dart';
import 'package:wtsp_clone/presentation/screens/updates/text_status_screen.dart';
import 'package:wtsp_clone/presentation/widgets/utils.dart';

class UpdatesScreen extends StatefulWidget {
  final Function(Uint8List?) onImageSelected;
  final Function(Map<String, dynamic>) onTextStatusAdded;

  const UpdatesScreen({
    super.key,
    required this.onImageSelected,
    required this.onTextStatusAdded,
  });

  @override
  _UpdatesScreenState createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends State<UpdatesScreen> {
  Uint8List? _statusImage;
  Uint8List? _image;
  Map<String, dynamic>? _textStatus;
  bool hasStatus = false;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _statusImage = img;
      hasStatus = true;
    });
    widget.onImageSelected(img);
  }

  void _uploadTextStatus(Map<String, dynamic> status) {
    setState(() {
      _textStatus = status;
      hasStatus = true;
    });
    widget.onTextStatusAdded(status);
  }

  void _viewStatus() {
    if (_textStatus != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StatusViewScreen(
            //image: _statusImage!,
            text: _textStatus!['text'],
            bgColor: _textStatus!['color'],
          ),
        ),
      );
    } else if (_statusImage != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageStatusView(
            image: _statusImage!,
          ),
        ),
      );
    }
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
            icon: Icon(Icons.camera_alt_outlined, color: Colors.black),
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
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: (_statusImage != null || _textStatus != null)
                          ? Border.all(color: Colors.green, width: 3)
                          : null,
                    ),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: _image != null
                          ? MemoryImage(_image!)
                          : AssetImage("assets/images/profile.jpg")
                              as ImageProvider,
                    ),
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
              // onTap: () {
              //   if (_statusImage != null) {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => ImageStatusView(
              //           image: _statusImage!,
              //           // text: _textStatus!['text'],
              //           // bgColor: _textStatus!['color'],
              //         ),
              //       ),
              //     );
              //   } else {
              //     selectImage();
              //   }
              // },
              onTap: () {
                if (_textStatus != null) {
                  _viewStatus();
                } else if (_statusImage != null) {
                  _viewStatus();
                } else {
                  selectImage();
                }
              },
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

              if (result != null && result is Map<String, dynamic>) {
                _uploadTextStatus(result);
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
