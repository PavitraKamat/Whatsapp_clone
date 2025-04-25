import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wtsp_clone/fireBaseHelper/search_contacts_helper.dart';
import 'package:wtsp_clone/fireBasemodel/models/user_model.dart';

class SelectContactProvider extends ChangeNotifier {
  List<UserModel> _contacts = [];
  List<UserModel> _filteredContacts = [];
  Map<String, Map<String, String>> _lastMessages = {};
  bool _isLoading = true;
  bool _isSearching = false;
  TextEditingController searchController = TextEditingController();

  List<UserModel> get contacts => _contacts;
  List<UserModel> get filteredContacts => _filteredContacts;
  Map<String, Map<String, String>> get lastMessages => _lastMessages;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;

  SelectContactProvider() {
    fetchUsersFromFirestore();
  }

  Future<void> fetchUsersFromFirestore() async {
    try {
      String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
      FirebaseFirestore.instance
          .collection('users')
          .snapshots()
          .listen((snapshot) {
        List<UserModel> users =
            snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
        UserModel? loggedInUser;
        users.removeWhere((user) {
          if (user.uid == currentUserId) {
            loggedInUser = user;
            return true;
          }
          return false;
        });
        users.sort((a, b) =>
            a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase()));

        if (loggedInUser != null) {
          users.insert(0, loggedInUser!);
        }
        _contacts = users;
        _filteredContacts = List.from(users);
        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      print("Error fetching users: $e");
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterContacts(String query) {
    // query = query.toLowerCase();
    // _filteredContacts = _contacts.where((user) {
    //   bool matchesName = user.firstName.toLowerCase().contains(query);
    //   bool matchesNumber =
    //       user.phone.replaceAll(RegExp(r'\D'), '').contains(query);

    //   return matchesName || matchesNumber;
    // }).toList();
    _filteredContacts = filterContactsHelper(_contacts, query);
    notifyListeners();
  }

  void toggleSearch() {
    _isSearching = !_isSearching;
    if (!_isSearching) {
      searchController.clear();
    }
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    filterContacts(query);
  }

  void disposeController() {
    searchController.dispose();
  }
}
