import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wtsp_clone/data/dataSources/wtsp_db.dart';

class ContactsProvider extends ChangeNotifier {
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  List<Map<String, String>> _lastMessages = [];
  bool _isLoading = false;

  List<Contact> get contacts => _contacts;
  List<Contact> get filteredContacts => _filteredContacts;
  List<Map<String, String>> get lastMessages => _lastMessages;
  bool get isLoading => _isLoading;

  ContactsProvider() {
    getContactPermission();
  }

  Future<void> getContactPermission() async {
    PermissionStatus status = await Permission.contacts.request();
    if (status.isGranted) {
      await _fetchContacts();
    }
  }

  Future<void> _fetchContacts() async {
    try {
      Iterable<Contact> contacts = await ContactsService.getContacts();
      List<Contact> contactList = contacts.toList();
      List<Map<String, String>> lastMessages = [];

      for (var contact in contactList) {
        String contactId = contact.phones!.isNotEmpty
            ? contact.phones!.first.value ?? "Unknown"
            : "Unknown";
        var lastMsg = await WtspDb.instance.getLastReceivedMessage(contactId);
        if (lastMsg != null) {
          lastMessages.add({'message': lastMsg.message, 'time': lastMsg.time});
        } else {
          lastMessages.add({'message': 'No messages', 'time': ''});
        }
      }
      _contacts = contactList;
      _filteredContacts = _contacts;
      _lastMessages = lastMessages;
      //print("Fetched Last Messages: $_lastMessages");
    } catch (e) {
      print("Error fetching contacts: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  void filterContacts(String query) {
    query = query.toLowerCase();
    _filteredContacts = _contacts.where((contact) {
      bool matchesName = contact.displayName != null &&
          contact.displayName!.toLowerCase().contains(query);

      bool matchesNumber = contact.phones != null &&
          contact.phones!.any((phone) =>
              phone.value != null &&
              phone.value!.replaceAll(RegExp(r'\D'), '').contains(query));

      return matchesName || matchesNumber;
    }).toList();
    notifyListeners();
  }
}
