import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/controller/settings_provider.dart';
import 'profile_edit_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SettingsAppBar(),
      body: Consumer<SettingsProvider>(
        builder: (context, provider, child) {
          return UserProfile(context, provider);
        },
      ),
    );
  }

  ListView UserProfile(BuildContext context, SettingsProvider provider) {
    return ListView(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileEditScreen(
                  image: provider.image,
                  name: provider.name,
                  status: provider.status,
                  phoneNumber: provider.phoneNumber,
                  onImageSelected: (img) => provider.selectImage(),
                  onNameChanged: (newName) => provider.updateName(newName),
                  onStatusChanged: (newStatus) =>
                      provider.updateStatus(newStatus),
                ),
              ),
            );
          },
          child: _buildProfileSection(provider),
        ),
        Divider(thickness: 1, color: Colors.grey[300]),
        _buildSettingsOption(Icons.lock, "Privacy"),
        _buildSettingsOption(Icons.notifications, "Notifications"),
        _buildSettingsOption(Icons.storage, "Storage and Data"),
        _buildSettingsOption(Icons.help_outline, "Help"),
        _buildSettingsOption(Icons.info_outline, "About"),
        SizedBox(height: 20),
      ],
    );
  }

  AppBar SettingsAppBar() {
    return AppBar(
      title: Text(
        "Settings",
        style: TextStyle(
          color: Colors.teal,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildProfileSection(SettingsProvider provider) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage:
                provider.image != null ? MemoryImage(provider.image!) : null,
            child: provider.image == null ? Icon(Icons.person, size: 40) : null,
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(provider.name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text(provider.status, style: TextStyle(color: Colors.grey[600])),
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
