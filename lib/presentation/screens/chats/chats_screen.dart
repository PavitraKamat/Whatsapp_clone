import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/controller/contact_provider.dart';
import 'package:wtsp_clone/data/models/contact_model.dart';
import 'package:wtsp_clone/presentation/screens/chats/individual_page.dart';

class ChatsScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  final List<String> profileImages = [
    "assets/images/profile.jpg",
    "assets/images/profile1.jpg",
    "assets/images/profile2.jpg",
    "assets/images/profile3.jpg",
    "assets/images/profile4.jpg",
  ];

  String getProfileImage(String identifier) {
    int index = identifier.hashCode % profileImages.length;
    return profileImages[index];
  }

  @override
  Widget build(BuildContext context) {
    final contactsProvider = Provider.of<ContactsProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search contacts...",
                prefixIcon: Icon(Icons.search, color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onChanged: (query) => contactsProvider.filterContacts(query),
            ),
          ),
          Expanded(
            child: contactsProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : contactsProvider.filteredContacts.isEmpty
                    ? Center(child: Text("No contacts found"))
                    : ListView.builder(
                        itemCount: contactsProvider.filteredContacts.length,
                        itemBuilder: (context, index) {
                          final contact =
                              contactsProvider.filteredContacts[index];
                          final contactId = contact.phones!.isNotEmpty
                              ? contact.phones!.first.value ?? "Unknown"
                              : "Unknown";
                          final lastMessage =
                              contactsProvider.lastMessages.isNotEmpty
                                  ? contactsProvider.lastMessages[index]
                                          ["message"] ??
                                      "No messages yet"
                                  : "No messages yet";
                          final lastTime = contactsProvider
                                  .lastMessages.isNotEmpty
                              ? contactsProvider.lastMessages[index]["time"] ??
                                  ""
                              : "";

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
                                      color: Color.fromARGB(255, 116, 115, 115),
                                      fontSize: 12),
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
                                  AssetImage(getProfileImage(contactId)),
                            ),
                            onTap: () {
                              ContactModel selectedContact = ContactModel(
                                id: contactId,
                                name: contact.displayName ?? "Unknown",
                                phone: contactId,
                                image: getProfileImage(contactId),
                                lastSeen: lastTime,
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      IndividualPage(contact: selectedContact),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
