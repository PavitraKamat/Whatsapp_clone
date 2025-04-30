import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/fireBaseController/contact_provider.dart';
import 'package:wtsp_clone/fireBaseHelper/user_profile_helper.dart';
import 'package:wtsp_clone/fireBasemodel/models/user_model.dart';
import 'package:wtsp_clone/fireBaseview/screens/chats/oneToOne_chat.dart';
import 'package:wtsp_clone/fireBaseview/screens/chats/select_contact_page.dart';

class FirebaseChatsScreen extends StatelessWidget {
  const FirebaseChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contactsProvider = Provider.of<FireBaseContactsProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          _buildSearchBar(contactsProvider, context),
          _buildContactsList(contactsProvider),
        ],
      ),
      floatingActionButton: selectContactButton(context),
    );
  }

  Expanded _buildContactsList(FireBaseContactsProvider contactsProvider) {
    return Expanded(
        child: contactsProvider.filteredContacts.isEmpty
            ? _buildEmptyChatPlaceholder()
            : Consumer<FireBaseContactsProvider>(
                builder: (context, contactsProvider, child) {
                final sortedContacts = contactsProvider.filteredContacts;
                return ListView.builder(
                  itemCount: sortedContacts.length,
                  itemBuilder: (context, index) {
                    final user = sortedContacts[index];
                    final userId = user.uid;
                    final lastMessage = contactsProvider.lastMessages[userId]
                            ?["message"] ??
                        "No messages yet";
                    final lastTime =
                        contactsProvider.lastMessages[userId]?["time"] ?? "";
                    return Column(
                      children: [
                        _buildUserTile(user, lastTime, lastMessage, context),
                        Divider(
                          height: 0.2,
                          thickness: 0.3,
                          indent: 12,
                          endIndent: 12,
                          color: Colors.grey[300],
                        ),
                      ],
                    );
                    // return _buildUserTile(
                    //     user, lastTime, lastMessage, context);
                  },
                );
              }));
  }

  Center _buildEmptyChatPlaceholder() {
    return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.chat_bubble_outline,
                        size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      "No chats yet",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Tap the + button below to start a conversation with someone!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            );
  }

  ListTile _buildUserTile(UserModel user, String lastTime, String lastMessage,
      BuildContext context) {
    return ListTile(
      title: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Text(
            user.uid == FirebaseAuth.instance.currentUser?.uid
                ? '${user.firstName} (You)'
                : user.firstName,
          )),
          Text(
            lastTime,
            style: TextStyle(
                color: Color.fromARGB(255, 116, 115, 115), fontSize: 12),
          ),
        ],
      ),
      subtitle: Text(
        lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      leading: UserProfileHelper(
          photoUrl: user.photoURL, phone: user.phone, radius: 24),
      //minLeadingWidth: 100,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FireBaseOnetooneChat(user: user),
          ),
        );
      },
    );
  }

  // Padding _buildSearchBar(
  //     FireBaseContactsProvider contactsProvider, BuildContext context) {
  //   return Padding(
  //     //height: 60.0,
  //     //child: Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0),
  //     child: TextField(
  //       controller: contactsProvider.searchController,
  //       decoration: InputDecoration(
  //         hintText: "Ask Meta AI or Search",
  //         hintStyle: TextStyle(color: Colors.black54),
  //         prefixIcon: Icon(Icons.search, color: Colors.black54),
  //         filled: true,
  //         fillColor: Color(0xFFF1F4F3),
  //         suffixIcon: contactsProvider.searchController.text.isNotEmpty
  //             ? IconButton(
  //                 icon: Icon(Icons.close, color: Colors.black, size: 18),
  //                 onPressed: () {
  //                   contactsProvider.searchController.clear();
  //                   contactsProvider.filterContacts('');
  //                   FocusScope.of(context).unfocus();
  //                 },
  //               )
  //             : null,
  //         contentPadding: EdgeInsets.symmetric(vertical: 12.0),
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(25.0),
  //           borderSide: BorderSide.none,
  //         ),
  //       ),
  //       onChanged: (value) {
  //         contactsProvider.filterContacts(value);
  //       },
  //     ),
  //     //),
  //   );
  // }

  Padding _buildSearchBar(
    FireBaseContactsProvider contactsProvider, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0),
    child: SizedBox(
      height: 40, // Set overall height of the TextField
      child: TextField(
        controller: contactsProvider.searchController,
        style: const TextStyle(fontSize: 14), // smaller text
        decoration: InputDecoration(
          hintText: "Ask Meta AI or Search",
          hintStyle: const TextStyle(color: Colors.black54, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: Colors.black54, size: 20),
          filled: true,
          fillColor: const Color(0xFFF1F4F3),
          suffixIcon: contactsProvider.searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: Colors.black, size: 18),
                  onPressed: () {
                    contactsProvider.searchController.clear();
                    contactsProvider.filterContacts('');
                    FocusScope.of(context).unfocus();
                  },
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(
              vertical: 0, horizontal: 12), // reduces internal padding
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          contactsProvider.filterContacts(value);
        },
      ),
    ),
  );
}


  FloatingActionButton selectContactButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectContactPage(),
          ),
        );
      },
      backgroundColor: Color.fromARGB(255, 108, 193, 149),
      child: Icon(
        Icons.add_box,
        color: Colors.white,
      ),
    );
  }
}
