import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/controller/profile_provider.dart';
import 'package:wtsp_clone/presentation/components/bottom_sheet.dart';
import 'package:wtsp_clone/presentation/components/profile_avatar.dart';

class ProfileEditScreen extends StatelessWidget {
  @override
  void _showEditBottomSheet({
    required BuildContext context,
    required String title,
    required TextEditingController controller,
    required Function(String) onSave,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => EditBottomSheet(
        title: title,
        controller: controller,
        onSave: onSave,
      ),
    );
  }

  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final nameController = TextEditingController(text: profileProvider.name);
    final statusController =
        TextEditingController(text: profileProvider.status);

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Center(
            child: ProfileAvatar(
                image: profileProvider.image,
                radius: 60,
                onTap: () => profileProvider.selectImage()),
          ),
          SizedBox(height: 30),
          ListTile(
            leading: Icon(Icons.person, color: Colors.teal),
            title: Text("Name", style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(profileProvider.name),
            onTap: () => _showEditBottomSheet(
              context: context,
              title: "Name",
              controller: nameController,
              onSave: profileProvider.updateName,
            ),
          ),
          ListTile(
            leading: Icon(Icons.info, color: Colors.teal),
            title: Text("About", style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(profileProvider.status),
            onTap: () => _showEditBottomSheet(
              context: context,
              title: "About",
              controller: statusController,
              onSave: profileProvider.updateStatus,
            ),
          ),
          ListTile(
            leading: Icon(Icons.phone, color: Colors.teal),
            title: Text("Phone Number",
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(profileProvider.phoneNumber),
          ),
        ],
      ),
    );
  }
}
