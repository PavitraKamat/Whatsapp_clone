import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/fireBaseController/select_contact_provider.dart';
import 'package:wtsp_clone/fireBasemodel/models/profile_image_helper.dart';
import 'package:wtsp_clone/fireBasemodel/models/user_model.dart';
import 'package:wtsp_clone/fireBaseview/components/pop_up_menu.dart';
import 'package:wtsp_clone/fireBaseview/screens/chats/oneToOne_chat.dart';

// class SelectContactPage extends StatefulWidget {
//   @override
//   _SelectContactPageState createState() => _SelectContactPageState();
// }

// class _SelectContactPageState extends State<SelectContactPage> {
//   @override
//   Widget build(BuildContext context) {
//     final contactsProvider = Provider.of<SelectContactProvider>(context);
//     //final profileProvider = Provider.of<ProfileProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//           title: Align(
//             alignment: Alignment.centerLeft,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Select contact",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   "${contactsProvider.filteredContacts.length} contacts",
//                   style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
//                 ),
//                 //Divider(color: const Color.fromARGB(255, 185, 184, 184)),
//               ],
//             ),
//           ),
//           backgroundColor: Colors.white,
//           foregroundColor: Colors.black,
//           elevation: 0,
//           scrolledUnderElevation: 0,
//           actions: [
//             IconButton(
//               icon: Icon(Icons.search),
//               onPressed: () {},
//             ),
//             PopupMenu(),
//           ]),
//       body: CustomScrollView(
//         slivers: [
//           SliverToBoxAdapter(
//             child: Column(
//               children: [
//                 buildOption(Icons.group, "New group"),
//                 buildOption(Icons.person_add, "New contact",
//                     trailingIcon: Icons.qr_code),
//                 buildOption(Icons.groups, "New community"),
//                 buildOption(Icons.smart_toy, "Chat with AIs"),
//                 const Divider(),
//                 const Padding(
//                   padding:
//                       EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       "Contacts on WhatsApp",
//                       style: TextStyle(color: Colors.grey, fontSize: 14),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           contactsProvider.isLoading
//               ? SliverFillRemaining(
//                   child: Center(child: CircularProgressIndicator()),
//                 )
//               : contactsProvider.filteredContacts.isEmpty
//                   ? SliverFillRemaining(
//                       child: Center(
//                           child: Text("No users found",
//                               style: TextStyle(fontSize: 16))),
//                     )
//                   : SliverList(
//                       delegate: SliverChildBuilderDelegate(
//                         (context, index) {
//                           final user = contactsProvider.filteredContacts[index];
//                           return _buildUserTile(user, context);
//                         },
//                         childCount: contactsProvider.filteredContacts.length,
//                       ),
//                     ),
//         ],
//       ),
//     );
//   }

//   Widget _buildUserTile(UserModel user, BuildContext context) {
//     return ListTile(
//       leading: CircleAvatar(
//         radius: 20,
//         backgroundImage: user.photoURL.isNotEmpty
//             ? NetworkImage(user.photoURL)
//             : AssetImage(ProfileImageHelper.getProfileImage(user.phone))
//                 as ImageProvider,
//       ),
//       title: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//               child: Text(
//             user.uid == FirebaseAuth.instance.currentUser?.uid
//                 ? '${user.firstName} (You)'
//                 : user.firstName,
//           )),
//         ],
//       ),
//       subtitle: Text(
//         user.aboutInfo,
//         maxLines: 1,
//         overflow: TextOverflow.ellipsis,
//         style: const TextStyle(color: Colors.grey),
//       ),
//       onTap: () {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => FireBaseOnetooneChat(user: user),
//           ),
//         );
//         // Navigator.pop(
//         //   context,
//         //   MaterialPageRoute(
//         //     builder: (context) => FirebaseChatsScreen(),
//         //   ),
//         // );
//         //Provider.of<FireBaseContactsProvider>(context, listen: false).fetchChatHistoryUsers();
//       },
//     );
//   }

//   Widget buildOption(IconData icon, String title, {IconData? trailingIcon}) {
//     return ListTile(
//       leading: CircleAvatar(
//         backgroundColor: Colors.green,
//         child: Icon(icon, color: Colors.white),
//       ),
//       title: Text(title, style: const TextStyle(fontSize: 16)),
//       trailing:
//           trailingIcon != null ? Icon(trailingIcon, color: Colors.grey) : null,
//     );
//   }
// }


class SelectContactPage extends StatefulWidget {
  @override
  _SelectContactPageState createState() => _SelectContactPageState();
}

class _SelectContactPageState extends State<SelectContactPage> {
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final contactsProvider = Provider.of<SelectContactProvider>(context);

    return Scaffold(
      appBar: _isSearching ? _buildSearchAppBar() : _buildDefaultAppBar(contactsProvider),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                buildOption(Icons.group, "New group"),
                buildOption(Icons.person_add, "New contact", trailingIcon: Icons.qr_code),
                buildOption(Icons.groups, "New community"),
                buildOption(Icons.smart_toy, "Chat with AIs"),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Contacts on WhatsApp",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
          contactsProvider.isLoading
              ? SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
              : contactsProvider.filteredContacts.isEmpty
                  ? SliverFillRemaining(child: Center(child: Text("No users found", style: TextStyle(fontSize: 16))))
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final user = contactsProvider.filteredContacts[index];
                          return _buildUserTile(user, context);
                        },
                        childCount: contactsProvider.filteredContacts.length,
                      ),
                    ),
        ],
      ),
    );
  }

  /// **Default AppBar**
  AppBar _buildDefaultAppBar(SelectContactProvider contactsProvider) {
    return AppBar(
      title: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select contact",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "${contactsProvider.filteredContacts.length} contacts",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      scrolledUnderElevation: 0,
      actions: [
        IconButton(
          icon: Icon(CupertinoIcons.search),
          onPressed: () {
            setState(() {
              _isSearching = true;
            });
          },
        ),
        PopupMenu(),
      ],
    );
  }

  /// **Search AppBar**
  AppBar _buildSearchAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      foregroundColor: Colors.black,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          setState(() {
            _isSearching = false;
            _searchController.clear();
          });
        },
      ),
      title: TextField(
        controller: _searchController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: "Search contacts...",
          border: InputBorder.none,
        ),
        onChanged: (query) {
          // Implement search functionality
          Provider.of<SelectContactProvider>(context, listen: false).filterContacts(query);
        },
      ),
    );
  }

  Widget _buildUserTile(UserModel user, BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: user.photoURL.isNotEmpty
            ? NetworkImage(user.photoURL)
            : AssetImage(ProfileImageHelper.getProfileImage(user.phone)) as ImageProvider,
      ),
      title: Text(user.uid == FirebaseAuth.instance.currentUser?.uid ? '${user.firstName} (You)' : user.firstName),
      subtitle: Text(user.aboutInfo, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey)),
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FireBaseOnetooneChat(user: user),
          ),
        );
      },
    );
  }

  Widget buildOption(IconData icon, String title, {IconData? trailingIcon}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Color.fromARGB(255, 108, 193, 149),
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: trailingIcon != null ? Icon(trailingIcon, color: Colors.grey) : null,
    );
  }
}
