import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wtsp_clone/data/dataSources/wtsp_db.dart';
import 'package:wtsp_clone/data/models/status_moodel.dart';
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
  List<Status> _statuses = [];
  final WtspDb _statusController = WtspDb();
  //List<Map<String, dynamic>> _statuses = [];

  @override
  void initState() {
    super.initState();
    _loadStatuses();
  }

  Future<void> _loadStatuses() async {
    List<Status> storedStatuses = await _statusController.getStatuses();
    setState(() {
      _statuses = storedStatuses;
    });
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    Status newStatus = Status(
      type: 'image',
      imageContent: img,
      timestamp: DateTime.now().toIso8601String(),
    );
    await _statusController.insertStatus(newStatus);
    _loadStatuses();
  }

  void _uploadTextStatus(Map<String, dynamic> status) async {
    Status newStatus = Status(
      type: 'text',
      textContent: status['text'],
      color: status['color'],
      timestamp: DateTime.now().toIso8601String(),
    );
    await _statusController.insertStatus(newStatus);
    _loadStatuses();
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
      appBar: AppBar(
        title: const Text("Updates",
            style: TextStyle(
                color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 22)),
        backgroundColor: Colors.white,
      ),
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
}
