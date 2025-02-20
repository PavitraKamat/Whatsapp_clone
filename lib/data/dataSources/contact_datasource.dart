// import 'dart:convert';
// import 'package:flutter/services.dart';
// import '../models/contact_model.dart';

// class ContactsDataSource {
//   Future<List<ContactModel>> fetchContacts() async {
//     try {
//       final String response =
//           await rootBundle.loadString('assets/contact.json');
//       final List<dynamic> data = json.decode(response);

//       return data.map((json) => ContactModel.fromJson(json)).toList();
//     } catch (e) {
//       throw Exception("Failed to load contacts: $e");
//     }
//   }
// }
