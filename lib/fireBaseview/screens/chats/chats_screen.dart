import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/fireBaseController/contact_provider.dart';
import 'package:wtsp_clone/fireBasemodel/models/profile_image_helper.dart';
import 'package:wtsp_clone/fireBasemodel/models/user_model.dart';
import 'package:wtsp_clone/fireBaseview/screens/chats/oneToOne_chat.dart';
import 'package:wtsp_clone/fireBaseview/screens/chats/select_contact_page.dart';

class FirebaseChatsScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final contactsProvider = Provider.of<FireBaseContactsProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          _buildSearchBar(contactsProvider),
          _buildContactsList(contactsProvider),
        ],
      ),
      floatingActionButton: FloatingActionButton(
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
          Icons.chat,
          color: Colors.white,
        ),
      ),
    );
  }

  Expanded _buildContactsList(FireBaseContactsProvider contactsProvider) {
    return Expanded(
        child: contactsProvider.isLoading
            ? Center(child: CircularProgressIndicator())
            : contactsProvider.filteredContacts.isEmpty
                ? Center(child: Text("No users found"))
                : Consumer<FireBaseContactsProvider>(
                    builder: (context, contactsProvider, child) {
                      final sortedContacts = contactsProvider.filteredContacts;
                    return ListView.builder(
                      itemCount: sortedContacts.length,
                      itemBuilder: (context, index) {
                        final user = sortedContacts[index];
                        final userId = user.uid;
                        final lastMessage =
                            contactsProvider.lastMessages[userId]?["message"] ??
                                "No messages yet";
                        final lastTime = contactsProvider.lastMessages[userId]
                                ?["time"] ??
                            "";
                        return _buildUserTile(
                            user, lastTime, lastMessage, context);
                      },
                    );
                  }));
  }

  ListTile _buildUserTile(UserModel user, String lastTime, String lastMessage,
      BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              user.firstName,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.black),
            ),
          ),
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
      leading: CircleAvatar(
        backgroundImage: user.photoURL.isNotEmpty
            ? NetworkImage(user.photoURL)
            : AssetImage(ProfileImageHelper.getProfileImage(user.phone)),
      ),
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

  Container _buildSearchBar(FireBaseContactsProvider contactsProvider) {
    return Container(
      height: 60.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "Ask Meta AI or Search",
            hintStyle: TextStyle(color: Colors.black54),
            prefixIcon: Icon(Icons.search, color: Colors.black54),
            filled: true,
            fillColor: Color(0xFFF1F4F3),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.close, color: Colors.black, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      contactsProvider.filterContacts('');
                      FocusScope.of(context as BuildContext).unfocus();
                    },
                  )
                : null,
            contentPadding: EdgeInsets.symmetric(vertical: 12.0),
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
}




