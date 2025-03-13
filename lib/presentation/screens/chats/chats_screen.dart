import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/controller/contact_provider.dart';
import 'package:wtsp_clone/data/models/contact_model.dart';
import 'package:wtsp_clone/data/models/profile_image_helper.dart';
import 'package:wtsp_clone/presentation/screens/chats/oneToOne_chat.dart';

class ChatsScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final contactsProvider = Provider.of<ContactsProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          _buildSearchBar(contactsProvider),
          _buildContactsList(contactsProvider),
        ],
      ),
    );
  }

  Expanded _buildContactsList(ContactsProvider contactsProvider) {
    return Expanded(
        child: contactsProvider.isLoading
            ? Center(child: CircularProgressIndicator())
            : contactsProvider.filteredContacts.isEmpty
                ? Center(child: Text("No contacts found"))
                : Consumer<ContactsProvider>(
                    builder: (context, contactsProvider, child) {
                    return ListView.builder(
                      itemCount: contactsProvider.filteredContacts.length,
                      itemBuilder: (context, index) {
                        final contact =
                            contactsProvider.filteredContacts[index];
                        final contactId = contact.phones!.isNotEmpty == true
                            ? contact.phones!.first.value ?? "Unknown"
                            : "Unknown";
                        final lastMessage = contactsProvider
                                    .lastMessages.isNotEmpty &&
                                index < contactsProvider.lastMessages.length
                            ? contactsProvider.lastMessages[index]["message"] ??
                                "No messages yet"
                            : "No messages yet";
                        final lastTime = contactsProvider
                                    .lastMessages.isNotEmpty &&
                                index < contactsProvider.lastMessages.length
                            ? contactsProvider.lastMessages[index]["time"] ?? ""
                            : "";
                        // print(
                        //     "DEBUG: UI - Contact: ${contactsProvider.filteredContacts[index].displayName} | Last Message: $lastMessage | Last Seen: $lastTime");

                        return _buildContactTile(
                            contact, lastTime, lastMessage, contactId, context);
                      },
                    );
                  }));
  }

  ListTile _buildContactTile(Contact contact, String lastTime,
      String lastMessage, String contactId, BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              contact.displayName ?? "No Name",
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
        backgroundImage:
            AssetImage(ProfileImageHelper.getProfileImage(contactId)),
      ),
      onTap: () {
        ContactModel selectedContact = ContactModel(
          id: contactId,
          name: contact.displayName ?? "Unknown",
          phone: contactId,
          image: ProfileImageHelper.getProfileImage(contactId),
          lastSeen: lastTime,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OnetooneChat(contact: selectedContact),
          ),
        );
      },
    );
  }

  Container _buildSearchBar(ContactsProvider contactsProvider) {
    return Container(
      height: 60.0,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "Search contacts...",
            prefixIcon: Icon(Icons.search, color: Colors.black),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.close, color: Colors.black, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      contactsProvider
                          .filterContacts(''); // Reset filtered contacts
                      FocusScope.of(context as BuildContext).unfocus();
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
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