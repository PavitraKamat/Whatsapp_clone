import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/controller/home_provider.dart';
import 'package:wtsp_clone/controller/profile_provider.dart';
import 'package:wtsp_clone/fireBaseHelper/profile_image_helper.dart';
import 'profile_edit_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final homeProvider = Provider.of<HomeProvider>(context);
    //print('${profileProvider.name}');
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
          _buildSettingsOption(CupertinoIcons.lock, "Privacy", () {}),
          _buildSettingsOption(CupertinoIcons.bell, "Notifications", () {}),
          _buildSettingsOption(
              CupertinoIcons.archivebox, "Storage and Data", () {}),
          _buildSettingsOption(CupertinoIcons.question_circle, "Help", () {}),
          _buildSettingsOption(CupertinoIcons.info, "About", () {}),
          SwitchListTile(
            title: Text(homeProvider.isFirebaseView
                ? "Using Firebase"
                : "Using Local Database"),
            secondary: Icon(Icons.storage),
            value: homeProvider.isFirebaseView,
            onChanged: (value) => homeProvider.toggleView(value),
          ),
          _buildSettingsOption(
              CupertinoIcons.square_arrow_right,
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
        //color: Colors.teal,
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
    padding: const EdgeInsets.all(10),
    child: Row(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),
            provider.imageUrl != null && provider.imageUrl!.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      provider.imageUrl!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return SizedBox(
                          width: 80,
                          height: 80,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.teal),
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes!)
                                  : null,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.error,
                        size: 40,
                        color: Colors.red,
                      ),
                    ),
                  )
                : CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(
                      ProfileImageHelper.getProfileImage(provider.phoneNumber),
                    ),
                  ),
          ],
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              provider.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              provider.about,
              style: TextStyle(color: Colors.grey[600]),
            ),
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
