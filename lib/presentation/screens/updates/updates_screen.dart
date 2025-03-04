import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wtsp_clone/presentation/screens/updates/status_viewer_screen.dart';
import 'package:wtsp_clone/presentation/screens/updates/text_status_screen.dart';
import 'package:wtsp_clone/presentation/components/profileAvatar.dart';
import 'package:wtsp_clone/presentation/components/status_tile.dart';
import 'package:wtsp_clone/presentation/components/floating_actions.dart';
import 'package:wtsp_clone/presentation/components/utils.dart';

class UpdatesScreen extends StatefulWidget {
  const UpdatesScreen({Key? key}) : super(key: key);
  @override
  _UpdatesScreenState createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends State<UpdatesScreen> {
  Uint8List? _image;
  List<Map<String, dynamic>> _statuses = [];
  String? _imagePath;
  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _statuses.add({'type': 'image', 'content': img});
    });
  }

  void _uploadTextStatus(Map<String, dynamic> status) {
    setState(() {
      _statuses.add({
        'type': 'text',
        'content': status['text'],
        'color': status['color']
      });
    });
  }

  void _viewStatuses() {
    if (_statuses.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StatusViewerScreen(statuses: _statuses)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UpdateScreenAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: ProfileAvataar(
                  image: _image,
                  onSelectImage: selectImage,
                  hasStatus: _statuses.isNotEmpty),
              title: const Text("My Status",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text("Tap to add status update"),
              onTap: _viewStatuses,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: const Text("Recent Updates",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            StatusTile(
              imagePath: "assets/images/contact1.jpg",
              name: "John Doe",
              subtitle: "Just now",
              onTap: () {},
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: const Text("Viewed Updates",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            StatusTile(
                imagePath: "assets/images/contact3.jpg",
                name: "Jane Smith",
                subtitle: "1 hour ago",
                onTap: () {}),
          ],
        ),
      ),
      floatingActionButton: FloatingActions(
        onTextStatus: () async {
          final result = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => TextStatusScreen()));
          if (result != null && result is Map<String, dynamic>)
            _uploadTextStatus(result);
        },
        onImageStatus: selectImage,
      ),
    );
  }

  AppBar UpdateScreenAppBar() {
    return AppBar(
      title: Text(
        "Updates",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.teal,
        ),
      ),
      backgroundColor: Colors.white,
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: Colors.black),
          onPressed: () {},
        ),
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: Colors.black),
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
    );
  }
}
