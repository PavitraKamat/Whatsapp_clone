import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/controller/profile_provider.dart';
import 'package:wtsp_clone/fireBasemodel/models/profile_image_helper.dart';
import '../../../fireBaseHelper/profile_image_helper.dart';
import 'profile_edit_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    //print("profileProvider ${profileProvider.name}");

    return Scaffold(
      appBar: settingsAppBar(),
      body: ListView(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileEditScreen(),
                ),
              );
            },
            child: _buildProfileSection(profileProvider),
          ),
          Divider(thickness: 1, color: Colors.grey[300]),
          _buildSettingsOption(Icons.lock, "Privacy", () {}),
          _buildSettingsOption(Icons.notifications, "Notifications", () {}),
          _buildSettingsOption(Icons.storage, "Storage and Data", () {}),
          _buildSettingsOption(Icons.help_outline, "Help", () {}),
          _buildSettingsOption(Icons.info_outline, "About", () {}),
          _buildSettingsOption(
              Icons.switch_access_shortcut_add, "Firebase View", () {}),
          _buildSettingsOption(
              Icons.logout,
              "Logout",
              () => Provider.of<ProfileProvider>(context, listen: false)
                  .logout(context)),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

AppBar settingsAppBar() {
  return AppBar(
    title: Text(
      "Settings",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 22,
        color: Color.fromARGB(255, 108, 193, 149),
      ),
    ),
    backgroundColor: Colors.white,
    actions: [
      IconButton(
        icon: Icon(Icons.search, color: Colors.black),
        onPressed: () {},
      ),
    ],
  );
}

Widget _buildProfileSection(ProfileProvider provider) {
  return Container(
    padding: EdgeInsets.all(10),
    child: Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage:
              provider.imageUrl != null && provider.imageUrl!.isNotEmpty
                  ? NetworkImage(provider.imageUrl!) as ImageProvider
                  : AssetImage(
                      ProfileImageHelper.getProfileImage(provider.phoneNumber)),
        ),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(provider.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(provider.about, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ],
    ),
  );
}

Widget _buildSettingsOption(IconData icon, String title, VoidCallback onTap) {
  return ListTile(
    leading: Icon(icon),
    title: Text(title),
    trailing: Icon(Icons.arrow_forward_ios, size: 16),
    onTap: onTap,
  );
}
