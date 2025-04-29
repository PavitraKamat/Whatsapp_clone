import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/controller/home_provider.dart';
import 'package:wtsp_clone/controller/profile_provider.dart';
import 'profile_edit_screen.dart';

// class SettingsScreen extends StatelessWidget {
//   const SettingsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final profileProvider = Provider.of<ProfileProvider>(context);
//     final homeProvider = Provider.of<HomeProvider>(context);
//     //print('${profileProvider.name}');
//     return Scaffold(
//       appBar: settingsAppBar(),
//       body: ListView(
//         children: [
//           GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ProfileEditScreen(),
//                 ),
//               );
//             },
//             child: _buildProfileSection(profileProvider),
//           ),
//           Divider(thickness: 1, color: Colors.grey[300]),
//           _buildSettingsOption(CupertinoIcons.lock, "Privacy", () {}),
//           _buildSettingsOption(CupertinoIcons.bell, "Notifications", () {}),
//           _buildSettingsOption(
//               CupertinoIcons.archivebox, "Storage and Data", () {}),
//           _buildSettingsOption(CupertinoIcons.question_circle, "Help", () {}),
//           _buildSettingsOption(CupertinoIcons.info, "About", () {}),
//           SwitchListTile(
//             title: Text(homeProvider.isFirebaseView
//                 ? "Using Firebase"
//                 : "Using Local Database"),
//             secondary: Icon(Icons.storage),
//             value: homeProvider.isFirebaseView,
//             onChanged: (value) => homeProvider.toggleView(value),
//           ),
//           _buildSettingsOption(
//               CupertinoIcons.square_arrow_right,
//               "Logout",
//               () => Provider.of<ProfileProvider>(context, listen: false)
//                   .logout(context)),
//           SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }

// AppBar settingsAppBar() {
//   return AppBar(
//     title: Text(
//       "Settings",
//       style: TextStyle(
//         fontWeight: FontWeight.bold,
//         fontSize: 22,
//         color: Color.fromARGB(255, 108, 193, 149),
//         //color: Colors.teal,
//       ),
//     ),
//     backgroundColor: Colors.white,
//     actions: [
//       IconButton(
//         icon: Icon(Icons.search, color: Colors.black),
//         onPressed: () {},
//       ),
//     ],
//   );
// }

// Widget _buildProfileSection(ProfileProvider provider) {
//   return Container(
//     padding: const EdgeInsets.all(10),
//     child: Row(
//       children: [
//         Stack(
//           alignment: Alignment.center,
//           children: [
//             CircleAvatar(
//               radius: 40,
//               backgroundColor: Colors.grey[300],
//               child: Icon(Icons.person, size: 40, color: Colors.white),
//             ),
//             provider.imageUrl != null && provider.imageUrl!.isNotEmpty
//                 ? ClipOval(
//                     child: Image.network(
//                       provider.imageUrl!,
//                       width: 80,
//                       height: 80,
//                       fit: BoxFit.cover,
//                       loadingBuilder: (context, child, loadingProgress) {
//                         if (loadingProgress == null) return child;
//                         return SizedBox(
//                           width: 80,
//                           height: 80,
//                           child: Center(
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               valueColor:
//                                   AlwaysStoppedAnimation<Color>(Colors.teal),
//                               value: loadingProgress.expectedTotalBytes != null
//                                   ? loadingProgress.cumulativeBytesLoaded /
//                                       (loadingProgress.expectedTotalBytes!)
//                                   : null,
//                             ),
//                           ),
//                         );
//                       },
//                       errorBuilder: (context, error, stackTrace) => Icon(
//                         Icons.error,
//                         size: 40,
//                         color: Colors.red,
//                       ),
//                     ),
//                   )
//                 : CircleAvatar(
//                     radius: 40,
//                     backgroundImage: AssetImage(
//                       ProfileImageHelper.getProfileImage(provider.phoneNumber),
//                     ),
//                   ),
//           ],
//         ),
//         const SizedBox(width: 20),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               provider.name,
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 5),
//             Text(
//               provider.about,
//               style: TextStyle(color: Colors.grey[600]),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }

// Widget _buildSettingsOption(IconData icon, String title, VoidCallback onTap) {
//   return ListTile(
//     leading: Icon(icon),
//     title: Text(title),
//     trailing: Icon(Icons.arrow_forward_ios, size: 16),
//     onTap: onTap,
//   );
// }

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final homeProvider = Provider.of<HomeProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: settingsAppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          _buildProfileTile(profileProvider, context),
          const SizedBox(height: 30),
          settingsSection([
            settingsTile(CupertinoIcons.lock, Colors.blue, "Privacy"),
            const Divider(height: 1, indent: 60),
            settingsTile(CupertinoIcons.bell, Colors.blue, "Notifications"),
            const Divider(height: 1, indent: 60),
            settingsTile(
                CupertinoIcons.archivebox, Colors.grey, "Storage and Data"),
            const Divider(height: 1, indent: 60),
            settingsTile(CupertinoIcons.question_circle, Colors.pink, "Help"),
            const Divider(height: 1, indent: 60),
            settingsTile(CupertinoIcons.info, Colors.purple, "About"),
          ]),
          const SizedBox(height: 30),
          settingsSection([
            _buildSwitchTile(homeProvider),
          ]),
          const SizedBox(height: 30),
          settingsSection([
            settingsTile(CupertinoIcons.square_arrow_right,
                const Color.fromARGB(255, 181, 36, 26), "Logout", onTap: () {
              Provider.of<ProfileProvider>(context, listen: false)
                  .logout(context);
            }),
          ]),
        ],
      ),
    );
  }

  AppBar settingsAppBar() {
    return AppBar(
      title: const Text(
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
          icon: const Icon(Icons.search, color: Colors.black),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildProfileTile(ProfileProvider provider, BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: ListTile(
      leading: ClipOval(
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: 30, 
              backgroundColor: Colors.blue.shade100,
              child: const Icon(Icons.person, color: Colors.blue, size: 30),
            ),
            if (provider.imageUrl != null && provider.imageUrl!.isNotEmpty)
              Image.network(
                provider.imageUrl!,
                width: 60,  
                height: 60,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const SizedBox(); // keep default avatar while loading
                },
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error, size: 30, color: Colors.red),
              ),
          ],
        ),
      ),
      title: Text(
        provider.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(provider.about),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileEditScreen()),
        );
      },
    ),
  );
}


  Widget settingsSection(List<Widget> tiles) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: tiles),
    );
  }

  Widget settingsTile(IconData icon, Color iconColor, String title,
      {VoidCallback? onTap}) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor),
          ),
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap ?? () {},
        ),
      ],
    );
  }

  Widget _buildSwitchTile(HomeProvider homeProvider) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.storage, color: Colors.blue),
      ),
      title: Text(
        homeProvider.isFirebaseView ? "Using Firebase" : "Using Local Database",
      ),
      trailing: Switch(
        activeColor: Colors.blue,
        value: homeProvider.isFirebaseView,
        onChanged: (value) => homeProvider.toggleView(value),
      ),
    );
  }
}
