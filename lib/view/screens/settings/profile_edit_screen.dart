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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/controller/profile_provider.dart';
import 'package:wtsp_clone/fireBaseHelper/user_profile_helper.dart';
import 'package:wtsp_clone/view/components/bottom_sheet.dart';

class ProfileEditScreen extends StatelessWidget {
  const ProfileEditScreen({super.key});

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
    final aboutController = TextEditingController(text: profileProvider.about);

    return Scaffold(
      appBar: profileEditingAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(child: editableProfileImage(profileProvider)),
          const SizedBox(height: 40),
          _sectionCard(
            child: _editableListTile(
              context: context,
              icon: CupertinoIcons.person,
              title: "Name",
              subTitle: profileProvider.name,
              controller: nameController,
              onSave: profileProvider.updateName,
            ),
          ),
          const SizedBox(height: 10),
          _sectionCard(
            child: _editableListTile(
              context: context,
              icon: CupertinoIcons.info,
              title: "About",
              subTitle: profileProvider.about,
              controller: aboutController,
              onSave: profileProvider.updateStatus,
            ),
          ),
          const SizedBox(height: 10),
          _sectionCard(
            child: _editableListTile(
              context: context,
              //icon: CupertinoIcons.phone,
              title: "Phone Number",
              subTitle: profileProvider.phoneNumber,
              onSave: profileProvider.updatePhone,
            ),
          ),
        ],
      ),
    );
  }

  Widget editableProfileImage(ProfileProvider profileProvider) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 170, 169, 169),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: UserProfileHelper(photoUrl: profileProvider.imageUrl ?? "", phone: profileProvider.phoneNumber,radius: 60,),
        ),
        Positioned(
          bottom: 0,
          right: 4,
          child: InkWell(
            onTap: () => profileProvider.selectImage(),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 108, 193, 149),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add_a_photo, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
    //  return ProfileAvatar(
    //   image: profileProvider.imageUrl,
    //   radius: 60,
    //   onTap: () => profileProvider.selectImage(),
    // );
  }

  AppBar profileEditingAppBar() {
    return AppBar(
      title: const Text(
        "Edit Profile",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Color.fromARGB(255, 108, 193, 149),
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
    );
  }

  Widget _editableListTile({
    required BuildContext context,
    IconData? icon,
    required String title,
    required String subTitle,
    TextEditingController? controller,
    Function(String)? onSave,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      leading: Icon(icon, color: Color.fromARGB(255, 108, 193, 149)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subTitle),
      trailing: const Icon(Icons.edit, size: 18, color: Colors.grey),
      onTap: () {
        if (controller != null && onSave != null) {
          _showEditBottomSheet(
            context: context,
            title: title,
            controller: controller,
            onSave: onSave,
          );
        }
      },
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

