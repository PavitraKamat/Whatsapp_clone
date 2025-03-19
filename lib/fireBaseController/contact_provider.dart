import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wtsp_clone/fireBasemodel/models/user_model.dart';

class FireBaseContactsProvider extends ChangeNotifier {
  List<UserModel> _contacts = [];
  List<UserModel> _filteredContacts = [];
  Map<String, Map<String, String>> _lastMessages = {};
  bool _isLoading = true;

  List<UserModel> get contacts => _contacts;
  List<UserModel> get filteredContacts => _filteredContacts;
  Map<String, Map<String, String>> get lastMessages => _lastMessages;
  bool get isLoading => _isLoading;

  FireBaseContactsProvider() {
    fetchUsersFromFirestore();
  }

  Future<void> fetchUsersFromFirestore() async {
    try {
      _isLoading = true;
      notifyListeners();

      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').get();

      _contacts =
          snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
      _filteredContacts = _contacts;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print("Error fetching users: $e");
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterContacts(String query) {
    query = query.toLowerCase();
    _filteredContacts = _contacts.where((user) {
      bool matchesName = user.firstName.toLowerCase().contains(query);
      bool matchesNumber =
          user.phone.replaceAll(RegExp(r'\D'), '').contains(query);

      return matchesName || matchesNumber;
    }).toList();
    notifyListeners();
  }

  void updateLastMessage(String userId, String message, String time) {
    _lastMessages[userId] = {"message": message, "time": time};
    notifyListeners();
  }
}
