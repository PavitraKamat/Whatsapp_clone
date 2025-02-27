import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wtsp_clone/data/dataSources/wtsp_db.dart';
import 'profile_edit_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Uint8List? _image;
  String name = "Alice";
  String status = "Hey there! I'm using WhatsApp";
  String phoneNumber = "+91 9876543210";
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    _loadImage();
  }

  Future<void> _loadProfileData() async {
    final profile = await WtspDb.instance.getProfile();

    if (profile.isNotEmpty) {
      String? imagePath = profile['imagePath'];
      Uint8List? imageBytes;

      if (imagePath != null && imagePath.isNotEmpty) {
        File imgFile = File(imagePath);
        if (await imgFile.exists()) {
          imageBytes = await imgFile.readAsBytes();
        } else {
          print("Image file does not exist at path: $imagePath");
        }
      }
      setState(() {
        name = profile['name'] ?? name;
        status = profile['status'] ?? status;
        _imagePath = imagePath;
        _image = imageBytes;
      });
    }
  }

  Future<void> _saveProfileData() async {
    if (_imagePath == null) return;
    await WtspDb.instance.saveProfile(name, status, _imagePath!);
  }

  void selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      Uint8List imgBytes = await pickedFile.readAsBytes();
      await _saveImage(imgBytes);
    }
  }

  Future<void> _saveImage(Uint8List imageBytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/profile_image.png';
    File file = File(filePath);
    await file.writeAsBytes(imageBytes);

    setState(() {
      _imagePath = filePath;
      _image = imageBytes;
    });

    await _saveProfileData(); // Save path to DB
  }

  void _loadImage() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/profile_image.png';
    File file = File(filePath);

    if (file.existsSync()) {
      Uint8List imgBytes = await file.readAsBytes();
      setState(() {
        _image = imgBytes;
      });
      print("Loaded saved image.");
    } else {
      print("No saved image found.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(
            color: Colors.teal,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileEditScreen(
                    image: _image,
                    name: name,
                    status: status,
                    phoneNumber: phoneNumber,
                    onImageSelected: (img) {
                      setState(() {
                        _image = img;
                      });
                      _saveProfileData();
                    },
                    onNameChanged: (newName) {
                      setState(() {
                        name = newName;
                      });
                      _saveProfileData();
                    },
                    onStatusChanged: (newStatus) {
                      setState(() {
                        status = newStatus;
                      });
                      _saveProfileData();
                    },
                  ),
                ),
              );
            },
            child: _buildProfileSection(),
          ),
          Divider(thickness: 1, color: Colors.grey[300]),
          _buildSettingsOption(Icons.lock, "Privacy"),
          _buildSettingsOption(Icons.notifications, "Notifications"),
          _buildSettingsOption(Icons.storage, "Storage and Data"),
          _buildSettingsOption(Icons.help_outline, "Help"),
          _buildSettingsOption(Icons.info_outline, "About"),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: _image != null ? MemoryImage(_image!) : null,
            child: _image == null ? Icon(Icons.person, size: 40) : null,
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text(status, style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOption(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }
}
