import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/controller/profile_provider.dart';
import 'package:wtsp_clone/fireBaseController/select_contact_provider.dart';
import 'package:wtsp_clone/fireBasemodel/models/profile_image_helper.dart';
import 'package:wtsp_clone/fireBasemodel/models/user_model.dart';
import 'package:wtsp_clone/fireBaseview/screens/chats/oneToOne_chat.dart';

class SelectContactPage extends StatefulWidget {
  @override
  _SelectContactPageState createState() => _SelectContactPageState();
}

class _SelectContactPageState extends State<SelectContactPage> {
  @override
  Widget build(BuildContext context) {
    final contactsProvider = Provider.of<SelectContactProvider>(context);
    //final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
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
              //Divider(color: const Color.fromARGB(255, 185, 184, 184)),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                buildOption(Icons.group, "New group"),
                buildOption(Icons.person_add, "New contact",
                    trailingIcon: Icons.qr_code),
                buildOption(Icons.groups, "New community"),
                buildOption(Icons.smart_toy, "Chat with AIs"),
                const Divider(),
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
              ? SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              : contactsProvider.filteredContacts.isEmpty
                  ? SliverFillRemaining(
                      child: Center(
                          child: Text("No users found",
                              style: TextStyle(fontSize: 16))),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final user = contactsProvider.filteredContacts[index];
                          return _buildUserTile(user, context);
                        },
                        //await  profileProvider.loadProfileData();
                        childCount: contactsProvider.filteredContacts.length,
                      ),
                    ),
        ],
      ),
    );
  }

  Widget _buildUserTile(UserModel user, BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: user.photoURL.isNotEmpty
            ? NetworkImage(user.photoURL)
            : AssetImage(ProfileImageHelper.getProfileImage(user.phone))
                as ImageProvider,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              user.firstName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          // Text(
          //   lastTime,
          //   style: const TextStyle(color: Colors.grey, fontSize: 12),
          // ),
        ],
      ),
      subtitle: Text(
        user.aboutInfo,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.grey),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FireBaseOnetooneChat(user: user),
          ),
        );
        //Provider.of<FireBaseContactsProvider>(context, listen: false).fetchChatHistoryUsers();
      },
    );
  }

  Widget buildOption(IconData icon, String title, {IconData? trailingIcon}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.green,
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing:
          trailingIcon != null ? Icon(trailingIcon, color: Colors.grey) : null,
    );
  }
}
