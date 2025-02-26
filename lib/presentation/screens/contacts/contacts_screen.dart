// import 'package:flutter/material.dart';
// import 'package:contacts_service/contacts_service.dart';
// import 'package:intl/intl.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:wtsp_clone/data/models/contact_model.dart';
// import 'package:wtsp_clone/data/models/profile_image_helper.dart';
// import 'package:wtsp_clone/presentation/screens/chats/individual_page.dart';

// class ContactsScreen extends StatefulWidget {
//   @override
//   _ContactsScreenState createState() => _ContactsScreenState();
// }

// class _ContactsScreenState extends State<ContactsScreen> {
//   List<Contact> _contacts = [];
//   List<Contact> _filteredContacts = [];
//   TextEditingController _searchController = TextEditingController();

//   final List<String> profileImages = [
//     "assets/images/profile.jpg",
//     "assets/images/profile1.jpg",
//     "assets/images/profile2.jpg",
//     "assets/images/profile3.jpg",
//     "assets/images/profile4.jpg",
//   ];

//   String getProfileImage(String identifier) {
//     int index = getConsistentIndex(identifier);
//     return profileImages[index];
//   }

//   @override
//   void initState() {
//     super.initState();
//     getContactPermission();
//     _searchController.addListener(_filterContacts);
//   }

//   void getContactPermission() async {
//     PermissionStatus status = await Permission.contacts.request();
//     print("status requesting $status");

//     if (status.isGranted) {
//       print("Permission granted");
//       _fetchContacts();
//     }
//     if (status.isDenied) {
//       print("Permission denied");
//     }
//   }

//   Future<void> _fetchContacts() async {
//     try {
//       Iterable<Contact> contacts = await ContactsService.getContacts();
//       setState(() {
//         _contacts = contacts.toList();
//         _filteredContacts = _contacts;
//       });
//     } catch (e) {
//       print("Error fetching contacts: $e");
//     }
//   }

//   void _filterContacts() {
//     String query = _searchController.text.toLowerCase();
//     setState(() {
//       _filteredContacts = _contacts.where((contact) {
//         bool matchesName = contact.displayName != null &&
//             contact.displayName!.toLowerCase().contains(query);

//         bool matchesNumber = contact.phones != null &&
//             contact.phones!.any((phone) =>
//                 phone.value != null &&
//                 phone.value!.replaceAll(RegExp(r'\D'), '').contains(query));

//         return matchesName || matchesNumber;
//       }).toList();
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: "Search contacts...",
//                 prefixIcon: Icon(Icons.search, color: Colors.black),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: _filteredContacts.isEmpty
//                 ? Center(child: Text("No contacts found"))
//                 : ListView.builder(
//                     itemCount: _filteredContacts.length,
//                     itemBuilder: (context, index) {
//                       Contact contact = _filteredContacts[index];
//                       return ListTile(
//                         title: Text(contact.displayName ?? "No Name"),
//                         subtitle: Text(
//                           (contact.phones?.isNotEmpty ?? false)
//                               ? contact.phones!.first.value ?? "No Number"
//                               : "No Number",
//                         ),
//                         leading: (contact.avatar != null &&
//                                 contact.avatar!.isNotEmpty)
//                             ? CircleAvatar(
//                                 backgroundImage: MemoryImage(contact.avatar!),
//                               )
//                             : CircleAvatar(
//                                 backgroundImage: AssetImage(getProfileImage(
//                                     contact.phones!.isNotEmpty
//                                         ? contact.phones!.first.value ??
//                                             contact.displayName ??
//                                             "Unknown"
//                                         : contact.displayName ?? "Unknown")),
//                               ),
//                         onTap: () {
//                           // Convert Contact into ContactModel
//                           ContactModel selectedContact = ContactModel(
//                               id: contact.phones!.isNotEmpty
//                                   ? contact.phones!.first.value ?? "Unknown"
//                                   : "Unknown",
//                               name: contact.displayName ?? "Unknown",
//                               phone: contact.phones!.isNotEmpty
//                                   ? contact.phones!.first.value ?? "No Number"
//                                   : "No Number",
//                               image: getProfileImage(contact.phones!.isNotEmpty
//                                   ? contact.phones!.first.value ??
//                                       contact.displayName ??
//                                       "Unknown"
//                                   : contact.displayName ?? "Unknown"),
//                               lastSeen:
//                                   "Last seen at ${DateFormat('hh:mm a').format(DateTime.now())}");

//                           // Navigate to IndividualPage with the selected contact
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   IndividualPage(contact: selectedContact),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wtsp_clone/data/dataSources/chat_dataBase.dart';
import 'package:wtsp_clone/data/models/contact_model.dart';
import 'package:wtsp_clone/data/models/profile_image_helper.dart';
import 'package:wtsp_clone/presentation/screens/chats/individual_page.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _lastMessages = [];

  final List<String> profileImages = [
    "assets/images/profile.jpg",
    "assets/images/profile1.jpg",
    "assets/images/profile2.jpg",
    "assets/images/profile3.jpg",
    "assets/images/profile4.jpg",
  ];

  String getProfileImage(String identifier) {
    int index = getConsistentIndex(identifier);
    return profileImages[index];
  }

  @override
  void initState() {
    super.initState();
    getContactPermission();
    _searchController.addListener(_filterContacts);
  }

  void getContactPermission() async {
    PermissionStatus status = await Permission.contacts.request();
    if (status.isGranted) {
      _fetchContacts();
    }
  }

  // Future<void> _fetchContacts() async {
  //   try {
  //     Iterable<Contact> contacts = await ContactsService.getContacts();
  //     setState(() {
  //       _contacts = contacts.toList();
  //       _filteredContacts = _contacts;
  //     });
  //   } catch (e) {
  //     print("Error fetching contacts: $e");
  //   }
  // }

  Future<void> _fetchContacts() async {
    try {
      Iterable<Contact> contacts = await ContactsService.getContacts();
      List<Contact> contactList = contacts.toList();

      // Fetch last messages for each contact
      List<Map<String, String>> lastMessages = await Future.wait(
        contactList.map((contact) async {
          String contactId = contact.phones!.isNotEmpty
              ? contact.phones!.first.value ?? "Unknown"
              : "Unknown";
          return await ChatDatabase.instance.getLastMessage(contactId) ??
              {'message': 'No messages', 'time': ''};
        }),
      );

      setState(() {
        _contacts = contactList;
        _filteredContacts = _contacts;
        _lastMessages = lastMessages;
      });
    } catch (e) {
      print("Error fetching contacts: $e");
    }
  }

  void _filterContacts() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContacts = _contacts.where((contact) {
        bool matchesName = contact.displayName != null &&
            contact.displayName!.toLowerCase().contains(query);

        bool matchesNumber = contact.phones != null &&
            contact.phones!.any((phone) =>
                phone.value != null &&
                phone.value!.replaceAll(RegExp(r'\D'), '').contains(query));

        return matchesName || matchesNumber;
      }).toList();
    });
  }

  Future<Map<String, String>> getLastMessage(String contactId) async {
    return await ChatDatabase.instance.getLastMessage(contactId) ??
        {"message": "No messages yet", "timestamp": ""};
  }

  @override
  Widget build(BuildContext context) {
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
            ),
          ),
          Expanded(
            child: _filteredContacts.isEmpty
                ? Center(child: Text("No contacts found"))
                : ListView.builder(
                    itemCount: _filteredContacts.length,
                    itemBuilder: (context, index) {
                      Contact contact = _filteredContacts[index];
                      String contactId = contact.phones!.isNotEmpty
                          ? contact.phones!.first.value ?? "Unknown"
                          : "Unknown";
                      String lastMessage = _lastMessages.isNotEmpty
                          ? _lastMessages[index]["message"] ?? "No messages yet"
                          : "No messages yet";
                      String lastTime = _lastMessages.isNotEmpty
                          ? _lastMessages[index]["time"] ?? ""
                          : "";
                      return ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                contact.displayName ?? "No Name",
                                overflow: TextOverflow
                                    .ellipsis, // Prevents text overflow
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            Text(
                              lastTime,
                              style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 116, 115, 115),
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
