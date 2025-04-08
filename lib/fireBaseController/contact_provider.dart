import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:wtsp_clone/fireBasemodel/models/user_model.dart';

class FireBaseContactsProvider extends ChangeNotifier {
  List<UserModel> _contacts = [];
  List<UserModel> _filteredContacts = [];
  Map<String, Map<String, dynamic>> _lastMessages = {};
  bool _isLoading = true;

  List<UserModel> get contacts => _contacts;
  List<UserModel> get filteredContacts => _filteredContacts;
  Map<String, Map<String, dynamic>> get lastMessages => _lastMessages;
  bool get isLoading => _isLoading;

  FireBaseContactsProvider() {
    fetchChatHistoryUsers();
  }
  //USES SNAPSHOT FOR LIVE UPDATES
  Future<void> fetchChatHistoryUsers() async {
    try {
      //String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore.instance
          .collection("chats")
          .snapshots()
          .listen((querySnapshot) async {
        List<UserModel> allUsers = [];
        QuerySnapshot userSnapshot =
            await FirebaseFirestore.instance.collection('users').get();

        List<UserModel> users = userSnapshot.docs
            .map((doc) => UserModel.fromFirestore(doc))
            .toList();

        for (var user in users) {
          //if (user.uid == currentUserId) continue;
          String chatId = getChatId(user.uid);
          bool chatExists = querySnapshot.docs.any((doc) => doc.id == chatId);

          if (chatExists) {
            allUsers.add(user);
          }
        }

        _contacts = allUsers;
        _filteredContacts = List.from(_contacts);
        _isLoading = false;
        sortContacts(_contacts);
        sortContacts(_filteredContacts);
        notifyListeners();

        _fetchLastMessages();
      });
    } catch (e) {
      print("Error fetching users: $e");
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterContacts(String query) {
    query = query.toLowerCase().trim();
    _filteredContacts = _contacts.where((user) {
      bool matchesName = user.firstName.toLowerCase().contains(query);
      bool matchesNumber =
          user.phone.replaceAll(RegExp(r'\D'), '').contains(query);

      return matchesName || matchesNumber;
    }).toList();
    notifyListeners();
  }

  void _fetchLastMessages() {
    for (var contact in _contacts) {
      String chatId = getChatId(contact.uid);

      FirebaseFirestore.instance
          .collection("chats")
          .doc(chatId)
          .snapshots()
          .listen((chatDoc) {
        if (chatDoc.exists && chatDoc.data() != null) {
          var data = chatDoc.data();
          if (data != null &&
              data.containsKey('lastMessage') &&
              data.containsKey('lastMessageTime')) {
            String lastMsg = data['lastMessage'];
            Timestamp lastMsgTime = data['lastMessageTime'];
            String formattedTime = formatTimestamp(lastMsgTime);

            updateLastMessage(contact.uid, lastMsg, formattedTime, lastMsgTime);
          }
        }
      });
    }
  }

  String getChatId(String otherUserId) {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return "";
    return (currentUserId.hashCode <= otherUserId.hashCode)
        ? "$currentUserId\_$otherUserId"
        : "$otherUserId\_$currentUserId";
  }

  void updateLastMessage(
      String userId, String message, String time, Timestamp timestamp) {
    _lastMessages[userId] = {
      "message": message,
      "time": time,
      "timestamp": timestamp,
    };
    sortContacts(_contacts);
    sortContacts(_filteredContacts);
    notifyListeners();
  }

  void sortContacts(List<UserModel> list) {
    list.sort((a, b) {
      Timestamp timeA = _lastMessages[a.uid]?['timestamp'] ?? Timestamp(0, 0);
      Timestamp timeB = _lastMessages[b.uid]?['timestamp'] ?? Timestamp(0, 0);
      return timeB.compareTo(timeA); // Sort in descending order (latest first)
    });
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime messageDate = timestamp.toDate();
    DateTime now = DateTime.now();

    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(Duration(days: 1));
    DateTime messageDay =
        DateTime(messageDate.year, messageDate.month, messageDate.day);

    if (messageDay == today) {
      return DateFormat('hh:mm a').format(messageDate); // Today's messages
    } else if (messageDay == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('dd/MM/yyyy').format(messageDate); // Older messages
    }
  }
}
