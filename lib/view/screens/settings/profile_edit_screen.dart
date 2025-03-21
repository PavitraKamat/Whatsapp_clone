// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:wtsp_clone/controller/profile_provider.dart';
// import 'package:wtsp_clone/view/components/bottom_sheet.dart';
// import 'package:wtsp_clone/view/components/profile_avatar.dart';

// class ProfileEditScreen extends StatelessWidget {
//   void _showEditBottomSheet({
//     required BuildContext context,
//     required String title,
//     required TextEditingController controller,
//     required Function(String) onSave,
//   }) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (context) => EditBottomSheet(
//         title: title,
//         controller: controller,
//         onSave: onSave,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final profileProvider = Provider.of<ProfileProvider>(context);
//     final nameController = TextEditingController(text: profileProvider.name);
//     final statusController =
//         TextEditingController(text: profileProvider.status);

//     return Scaffold(
//       appBar: profileEditingAppBar(),
//       body: ListView(
//         padding: EdgeInsets.all(20),
//         children: [
//           Center(
//             child: editableProfileImage(profileProvider),
//           ),
//           SizedBox(height: 30),
//           _editableListTile(
//             context: context,
//             icon: Icons.person,
//             title: "Name",
//             subTitle: profileProvider.name,
//             controller: nameController,
//             onSave: profileProvider.updateName,
//           ),
//           _editableListTile(
//             context: context,
//             icon: Icons.info,
//             title: "About",
//             subTitle: profileProvider.status,
//             controller: statusController,
//             onSave: profileProvider.updateStatus,
//           ),
//           _editableListTile(
//             context: context,
//             icon: Icons.phone,
//             title: "Phone Number",
//             subTitle: profileProvider.phoneNumber,
//           ),
//         ],
//       ),
//     );
//   }

//   ProfileAvatar editableProfileImage(ProfileProvider profileProvider) {
//     return ProfileAvatar(
//       image: profileProvider.image,
//       radius: 60,
//       onTap: () => profileProvider.selectImage(),
//     );
//   }

//   AppBar profileEditingAppBar() {
//     return AppBar(
//       title: Text(
//         "Edit Profile",
//         style: TextStyle(
//           fontWeight: FontWeight.bold,
//           fontSize: 22,
//           color:Color.fromARGB(255, 108, 193, 149),
//         ),
//       ),
//       backgroundColor: Colors.white,
//       scrolledUnderElevation: 0,
//     );
//   }

//   Widget _editableListTile({
//     required BuildContext context,
//     required IconData icon,
//     required String title,
//     required String subTitle,
//     TextEditingController? controller,
//     Function(String)? onSave,
//   }) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.teal),
//       title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
//       subtitle: Text(subTitle),
//       onTap: () => _showEditBottomSheet(
//         context: context,
//         title: title,
//         controller: controller!,
//         onSave: onSave!,
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/controller/profile_provider.dart';
import 'package:wtsp_clone/view/components/bottom_sheet.dart';
import 'package:wtsp_clone/view/components/profile_avatar.dart';

class ProfileEditScreen extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final nameController = TextEditingController(text: profileProvider.name);
    final statusController =
        TextEditingController(text: profileProvider.about);

    return Scaffold(
      appBar: profileEditingAppBar(),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Center(
            child: editableProfileImage(profileProvider),
          ),
          SizedBox(height: 30),
          _editableListTile(
            context: context,
            icon: Icons.person,
            title: "Name",
            subTitle: profileProvider.name,
            controller: nameController,
            onSave: profileProvider.updateName,
          ),
          _editableListTile(
            context: context,
            icon: Icons.info,
            title: "About",
            subTitle: profileProvider.about,
            controller: statusController,
            onSave: profileProvider.updateStatus,
          ),
          _editableListTile(
            context: context,
            icon: Icons.phone,
            title: "Phone Number",
            subTitle: profileProvider.phoneNumber,
            onSave: profileProvider.updatePhone,
          ),
        ],
      ),
    );
  }

  ProfileAvatar editableProfileImage(ProfileProvider profileProvider) {
    return ProfileAvatar(
      image: profileProvider.image,
      radius: 60,
      onTap: () => profileProvider.selectImage(),
    );
  }

  AppBar profileEditingAppBar() {
    return AppBar(
      title: Text(
        "Edit Profile",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Color.fromARGB(255, 108, 193, 149),
        ),
      ),
      backgroundColor: Colors.white,
      scrolledUnderElevation: 0,
    );
  }

  Widget _editableListTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subTitle,
    TextEditingController? controller,
    Function(String)? onSave,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subTitle),
      onTap: () => _showEditBottomSheet(
        context: context,
        title: title,
        controller: controller!,
        onSave: onSave!,
      ),
    );
  }
}
