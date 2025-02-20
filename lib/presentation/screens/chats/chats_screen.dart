// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:wtsp_clone/data/models/contact_model.dart';
// import 'package:wtsp_clone/presentation/widgets/contact_tile.dart';

// class ChatsScreen extends StatefulWidget {
//   @override
//   _ChatsScreenState createState() => _ChatsScreenState();
// }

// class _ChatsScreenState extends State<ChatsScreen> {
//   List<ContactModel> _contacts = [];
//   List<ContactModel> _filteredContacts = [];
//   TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _loadContacts();
//     _searchController.addListener(_filterContacts);
//   }

//   Future<void> _loadContacts() async {
//     try {
//       final String response =
//           await rootBundle.loadString('assets/contacts/contact.json');
//       final List<dynamic> data = json.decode(response);

//       setState(() {
//         _contacts = data.map((json) => ContactModel.fromJson(json)).toList();
//         _filteredContacts = _contacts;
//       });
//     } catch (e) {
//       print("Error loading contacts: $e");
//     }
//   }

//   void _filterContacts() {
//     String query = _searchController.text.toLowerCase();
//     setState(() {
//       _filteredContacts = _contacts
//           .where((contact) =>
//               contact.name.toLowerCase().contains(query) ||
//               contact.phone.toLowerCase().contains(query))
//           .toList();
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
//                 : SingleChildScrollView(
//                     child: Column(
//                       children: _filteredContacts
//                           .map((contact) => ContactTile(contact: contact))
//                           .toList(),
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }
