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

  Future<void> fetchChatHistoryUsers() async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;

      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').get();

      List<UserModel> allUsers =
          snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();

      _contacts.clear();
      _filteredContacts.clear();

      for (var user in allUsers) {
        if (user.uid == currentUserId) continue;
        String chatId = _getChatId(user.uid);

        DocumentSnapshot chatDoc = await FirebaseFirestore.instance
            .collection("chats")
            .doc(chatId)
            .get();

        if (chatDoc.exists) {
          _contacts.add(user);
          _filteredContacts.add(user);
        }
      }

      _isLoading = false;
      notifyListeners();

      _fetchLastMessages();
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

  void _fetchLastMessages() {
    for (var contact in _contacts) {
      String chatId = _getChatId(contact.uid);

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

  String _getChatId(String otherUserId) {
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

    void sortContacts(List<UserModel> list) {
      list.sort((a, b) {
        Timestamp timeA = _lastMessages[a.uid]?['timestamp'] ?? Timestamp(0, 0);
        Timestamp timeB = _lastMessages[b.uid]?['timestamp'] ?? Timestamp(0, 0);
        return timeB
            .compareTo(timeA); // Sort in descending order (latest first)
      });
    }

    sortContacts(_contacts);
    sortContacts(_filteredContacts);

    notifyListeners();
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
      return DateFormat('dd/MM/yyyy hh:mm a')
          .format(messageDate); // Older messages
    }
  }
}
