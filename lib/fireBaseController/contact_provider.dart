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






// class FireBaseContactsProvider extends ChangeNotifier {
//   List<UserModel> _contacts = [];
//   List<UserModel> _filteredContacts = [];
//   Map<String, Map<String, dynamic>> _lastMessages = {};
//   bool _isLoading = true;

//   List<UserModel> get contacts => _contacts;
//   List<UserModel> get filteredContacts => _filteredContacts;
//   Map<String, Map<String, dynamic>> get lastMessages => _lastMessages;
//   bool get isLoading => _isLoading;

//   FireBaseContactsProvider() {
//     fetchChatHistoryUsers();
//   }

//   Future<void> fetchChatHistoryUsers() async {
//     try {
//       FirebaseFirestore.instance
//           .collection("chats")
//           .snapshots()
//           .listen((querySnapshot) async {
//         List<UserModel> allUsers = [];
//         QuerySnapshot userSnapshot =
//             await FirebaseFirestore.instance.collection('users').get();

//         List<UserModel> users = userSnapshot.docs
//             .map((doc) => UserModel.fromFirestore(doc))
//             .toList();

//         for (var user in users) {
//           String chatId = getChatId(user.uid);
//           bool chatExists = querySnapshot.docs.any((doc) => doc.id == chatId);

//           if (chatExists) {
//             allUsers.add(user);
//           }
//         }

//         _contacts = allUsers;
//         _filteredContacts = List.from(_contacts);
//         _isLoading = false;
//         sortContacts(_contacts);
//         sortContacts(_filteredContacts);
//         notifyListeners();

//         _fetchLastMessages();
//       });
//     } catch (e) {
//       print("Error fetching users: $e");
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   void filterContacts(String query) {
//     query = query.toLowerCase().trim();
//     _filteredContacts = _contacts.where((user) {
//       bool matchesName = user.firstName.toLowerCase().contains(query);
//       bool matchesNumber =
//           user.phone.replaceAll(RegExp(r'\D'), '').contains(query);

//       return matchesName || matchesNumber;
//     }).toList();
//     notifyListeners();
//   }

//   void _fetchLastMessages() {
//     String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
//     if (currentUserId == null) return;

//     for (var contact in _contacts) {
//       String chatId = getChatId(contact.uid);

//       FirebaseFirestore.instance
//           .collection("chats")
//           .doc(chatId)
//           .snapshots()
//           .listen((chatDoc) {
//         if (chatDoc.exists && chatDoc.data() != null) {
//           var data = chatDoc.data();
//           if (data != null && data.containsKey('lastMessage')) {
//             var lastMsgData = data['lastMessage'];
//             Timestamp lastMsgTime = lastMsgData['timestamp'];
//             String formattedTime = formatTimestamp(lastMsgTime);

//             MessageModel lastMsg = MessageModel.fromMap(lastMsgData);
//             String displayText = getLastMessageDisplay(lastMsg, currentUserId);

//             updateLastMessage(contact.uid, displayText, formattedTime, lastMsgTime);
//           }
//         }
//       });
//     }
//   }

//   String getLastMessageDisplay(MessageModel lastMsg, String currentUserId) {
//     if (lastMsg.isDeletedForEveryone) {
//       return lastMsg.senderId == currentUserId
//           ? "You deleted this message"
//           : "This message was deleted";
//     }

//     if (lastMsg.deletedFor.contains(currentUserId)) {
//     // Fallback to previous visible message
//     final previousVisibleMsg = chat.messages.reversed.firstWhere(
//       (msg) =>
//           !msg.isDeletedForEveryone &&
//           !msg.deletedFor.contains(currentUserId),
//       orElse: () => null,
//     );

//     return previousVisibleMsg != null
//         ? (previousVisibleMsg.messageType == MessageType.image
//             ? "[Image]"
//             : previousVisibleMsg.messageContent)
//         : "No messages yet";
//   }

//   // Normal message
//   return lastMsg.messageType == MessageType.image
//       ? "[Image]"
//       : lastMsg.messageContent;
// }

//   String getChatId(String otherUserId) {
//     String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
//     if (currentUserId == null) return "";
//     return (currentUserId.hashCode <= otherUserId.hashCode)
//         ? "$currentUserId\_$otherUserId"
//         : "$otherUserId\_$currentUserId";
//   }

//   void updateLastMessage(
//       String userId, String message, String time, Timestamp timestamp) {
//     _lastMessages[userId] = {
//       "message": message,
//       "time": time,
//       "timestamp": timestamp,
//     };
//     sortContacts(_contacts);
//     sortContacts(_filteredContacts);
//     notifyListeners();
//   }

//   void sortContacts(List<UserModel> list) {
//     list.sort((a, b) {
//       Timestamp timeA = _lastMessages[a.uid]?['timestamp'] ?? Timestamp(0, 0);
//       Timestamp timeB = _lastMessages[b.uid]?['timestamp'] ?? Timestamp(0, 0);
//       return timeB.compareTo(timeA);
//     });
//   }

//   String formatTimestamp(Timestamp timestamp) {
//     DateTime messageDate = timestamp.toDate();
//     DateTime now = DateTime.now();

//     DateTime today = DateTime(now.year, now.month, now.day);
//     DateTime yesterday = today.subtract(Duration(days: 1));
//     DateTime messageDay =
//         DateTime(messageDate.year, messageDate.month, messageDate.day);

//     if (messageDay == today) {
//       return DateFormat('hh:mm a').format(messageDate);
//     } else if (messageDay == yesterday) {
//       return 'Yesterday';
//     } else {
//       return DateFormat('dd/MM/yyyy').format(messageDate);
//     }
//   }
// }





// class FireBaseContactsProvider extends ChangeNotifier {
//   List<UserModel> _contacts = [];
//   List<UserModel> _filteredContacts = [];
//   Map<String, Map<String, dynamic>> _lastMessages = {};
//   bool _isLoading = true;

//   List<UserModel> get contacts => _contacts;
//   List<UserModel> get filteredContacts => _filteredContacts;
//   Map<String, Map<String, dynamic>> get lastMessages => _lastMessages;
//   bool get isLoading => _isLoading;

//   FireBaseContactsProvider() {
//     fetchChatHistoryUsers();
//   }

//   Future<void> fetchChatHistoryUsers() async {
//     try {
//       FirebaseFirestore.instance
//           .collection("chats")
//           .snapshots()
//           .listen((querySnapshot) async {
//         List<UserModel> allUsers = [];
//         QuerySnapshot userSnapshot =
//             await FirebaseFirestore.instance.collection('users').get();

//         List<UserModel> users = userSnapshot.docs
//             .map((doc) => UserModel.fromFirestore(doc))
//             .toList();

//         for (var user in users) {
//           String chatId = getChatId(user.uid);
//           bool chatExists = querySnapshot.docs.any((doc) => doc.id == chatId);

//           if (chatExists) {
//             allUsers.add(user);
//           }
//         }

//         _contacts = allUsers;
//         _filteredContacts = List.from(_contacts);
//         _isLoading = false;
//         sortContacts(_contacts);
//         sortContacts(_filteredContacts);
//         notifyListeners();

//         _fetchLastMessages();
//       });
//     } catch (e) {
//       print("Error fetching users: $e");
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   void filterContacts(String query) {
//     query = query.toLowerCase().trim();
//     _filteredContacts = _contacts.where((user) {
//       bool matchesName = user.firstName.toLowerCase().contains(query);
//       bool matchesNumber =
//           user.phone.replaceAll(RegExp(r'\D'), '').contains(query);

//       return matchesName || matchesNumber;
//     }).toList();
//     notifyListeners();
//   }

//   void _fetchLastMessages() {
//     String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
//     if (currentUserId == null) return;

//     for (var contact in _contacts) {
//       String chatId = getChatId(contact.uid);

//       FirebaseFirestore.instance
//           .collection("chats")
//           .doc(chatId)
//           .snapshots()
//           .listen((chatDoc) async {
//         if (chatDoc.exists && chatDoc.data() != null) {
//           var data = chatDoc.data();
//           if (data != null && data.containsKey('lastMessage')) {
//             var lastMsgData = data['lastMessage'];
//             Timestamp lastMsgTime = lastMsgData['timestamp'];
//             String formattedTime = formatTimestamp(lastMsgTime);

//             MessageModel lastMsg = MessageModel.fromMap(lastMsgData);

//             // Fetch the full chat to find previous visible message if needed
//             final messagesSnapshot = await FirebaseFirestore.instance
//                 .collection("chats")
//                 .doc(chatId)
//                 .collection("messages")
//                 .orderBy('timestamp', descending: true)
//                 .get();

//             List<MessageModel> messages = messagesSnapshot.docs
//                 .map((doc) => MessageModel.fromMap(doc.data()))
//                 .toList();

//             String displayText = getLastMessageDisplay(
//               lastMsg,
//               currentUserId,
//               messages,
//             );

//             updateLastMessage(contact.uid, displayText, formattedTime, lastMsgTime);
//           }
//         }
//       });
//     }
//   }

//   String getLastMessageDisplay(
//       MessageModel lastMsg,
//       String currentUserId,
//       List<MessageModel> messages,
//       ) {
//     if (lastMsg.isDeletedForEveryone) {
//       return lastMsg.senderId == currentUserId
//           ? "You deleted this message"
//           : "This message was deleted";
//     }

//     if (lastMsg.deletedFor.contains(currentUserId)) {
//       final previousVisibleMsg = messages.firstWhere(
//             (msg) =>
//         !msg.isDeletedForEveryone &&
//             !msg.deletedFor.contains(currentUserId),
//         orElse: () => MessageModel.empty(),
//       );

//       if (previousVisibleMsg.messageId.isEmpty) return "No messages yet";

//       return previousVisibleMsg.messageType == MessageType.image
//           ? "[Image]"
//           : previousVisibleMsg.messageContent;
//     }

//     return lastMsg.messageType == MessageType.image
//         ? "[Image]"
//         : lastMsg.messageContent;
//   }

//   String getChatId(String otherUserId) {
//     String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
//     if (currentUserId == null) return "";
//     return (currentUserId.hashCode <= otherUserId.hashCode)
//         ? "$currentUserId\_$otherUserId"
//         : "$otherUserId\_$currentUserId";
//   }

//   void updateLastMessage(
//       String userId, String message, String time, Timestamp timestamp) {
//     _lastMessages[userId] = {
//       "message": message,
//       "time": time,
//       "timestamp": timestamp,
//     };
//     sortContacts(_contacts);
//     sortContacts(_filteredContacts);
//     notifyListeners();
//   }

//   void sortContacts(List<UserModel> list) {
//     list.sort((a, b) {
//       Timestamp timeA = _lastMessages[a.uid]?['timestamp'] ?? Timestamp(0, 0);
//       Timestamp timeB = _lastMessages[b.uid]?['timestamp'] ?? Timestamp(0, 0);
//       return timeB.compareTo(timeA);
//     });
//   }

//   String formatTimestamp(Timestamp timestamp) {
//     DateTime messageDate = timestamp.toDate();
//     DateTime now = DateTime.now();

//     DateTime today = DateTime(now.year, now.month, now.day);
//     DateTime yesterday = today.subtract(Duration(days: 1));
//     DateTime messageDay =
//         DateTime(messageDate.year, messageDate.month, messageDate.day);

//     if (messageDay == today) {
//       return DateFormat('hh:mm a').format(messageDate);
//     } else if (messageDay == yesterday) {
//       return 'Yesterday';
//     } else {
//       return DateFormat('dd/MM/yyyy').format(messageDate);
//     }
//   }
// }
