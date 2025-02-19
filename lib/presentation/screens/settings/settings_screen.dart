import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wtsp_clone/presentation/widgets/utils.dart';
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

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
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
                    },
                    onNameChanged: (newName) {
                      setState(() {
                        name = newName;
                      });
                    },
                    onStatusChanged: (newStatus) {
                      setState(() {
                        status = newStatus;
                      });
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
