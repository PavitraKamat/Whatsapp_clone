import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wtsp_clone/fireBasemodel/models/status_model.dart';

// class StatusProvider extends ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   String? _imageUrl;
//   List<StatusModel> _statuses = [];

//   List<StatusModel> get statuses => _statuses;
//   String? get imageUrl => _imageUrl;

//   Future<void> selectImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       File imageFile = File(pickedFile.path); // Convert to File
//       await _uploadImage(imageFile);
//     }
//   }

//   Future<void> _uploadImage(File imageFile) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;

//     try {
//       // Reference to Firebase Storage
//       Reference ref = FirebaseStorage.instance
//           .ref()
//           .child('profile_pictures')
//           .child('${user.uid}.jpg');

//       // Upload file directly
//       UploadTask uploadTask = ref.putFile(imageFile);
//       TaskSnapshot snapshot = await uploadTask;
//       String downloadUrl = await snapshot.ref.getDownloadURL();
//       _imageUrl = downloadUrl;

//       // Save URL in Firestore
//       await FirebaseFirestore.instance
//           .collection('status')
//           .doc(user.uid)
//           .update({
//         'mediaUrl': imageUrl,
//       });

//       notifyListeners();
//     } catch (e) {
//       debugPrint("Error uploading image: $e");
//     }
//   }

//   Future<void> fetchStatuses() async {
//     final snapshot = await FirebaseFirestore.instance
//         .collection('statuses')
//         .orderBy('timestamp', descending: true)
//         .get();

//     _statuses =
//         snapshot.docs.map((doc) => StatusModel.fromMap(doc.data())).toList();

//     notifyListeners();
//   }

//   Future<void> addTextStatus(
//       String userId, String username, String text, String color) async {
//     final status = StatusModel(
//       statusId: DateTime.now().millisecondsSinceEpoch.toString(),
//       userId: userId,
//       username: username,
//       statusType: StatusType.text,
//       textContent: text,
//       color: color,
//       mediaUrl: null,
//       timestamp: DateTime.now(),
//       viewedBy: [],
//     );

//     await FirebaseFirestore.instance
//         .collection('statuses')
//         .doc(status.statusId)
//         .set(status.toMap());
//     notifyListeners();

//     await fetchStatuses(); // Refresh list
//   }

//   Future<void> addImageStatus(
//       String userId, String username, String imageUrl) async {
//     final status = StatusModel(
//       statusId: DateTime.now().millisecondsSinceEpoch.toString(),
//       userId: userId,
//       username: username,
//       statusType: StatusType.image,
//       mediaUrl: imageUrl,
//       textContent: "Image",
//       color: null,
//       timestamp: DateTime.now(),
//       viewedBy: [],
//     );

//     await FirebaseFirestore.instance
//         .collection('statuses')
//         .doc(status.statusId)
//         .set(status.toMap());

//     await fetchStatuses(); // Refresh list
//   }
//   Future<void> markStatusAsViewed(String statusId, String currentUserId) async {
//     try {
//       final DocumentSnapshot statusDoc =
//           await _firestore.collection('statuses').doc(statusId).get();
//       if (statusDoc.exists) {
//         final statusData = statusDoc.data() as Map<String, dynamic>;
//         List<String> viewedBy = List<String>.from(statusData['viewedBy'] ?? []);

//         if (!viewedBy.contains(currentUserId)) {
//           viewedBy.add(currentUserId);
//           await _firestore
//               .collection('statuses')
//               .doc(statusId)
//               .update({'viewedBy': viewedBy});
//         }
//       }
//     } catch (e) {
//       print('Error marking status as viewed: $e');
//     }
//   }

//   bool hasStatus() {
//     return _statuses.isNotEmpty;
//   }
// }

// class StatusProvider extends ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;

//   // State variables
//   List<StatusModel> _statuses = [];
//   bool _isLoading = false;

//   // Getters
//   List<StatusModel> get statuses => _statuses;
//   bool get isLoading => _isLoading;

//   StatusProvider() {
//     // Initialize by fetching statuses
//     fetchStatuses();
//   }

//   // Select image from gallery and upload as status
//   Future<void> selectImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       File imageFile = File(pickedFile.path); // Convert to File
//       await _uploadImage(imageFile);
//     }
//   }
//   Future<void> _uploadImage(File imageFile) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;

//     try {
//       // Reference to Firebase Storage
//       Reference ref = FirebaseStorage.instance
//           .ref()
//           .child('profile_pictures')
//           .child('${user.uid}.jpg');

//       // Upload file directly
//       UploadTask uploadTask = ref.putFile(imageFile);
//       TaskSnapshot snapshot = await uploadTask;
//       String downloadUrl = await snapshot.ref.getDownloadURL();

//       // Save URL in Firestore
//       await FirebaseFirestore.instance
//           .collection('status')
//           .doc(user.uid)
//           .update({
//         'mediaUrl': downloadUrl,
//       });

//       notifyListeners();
//     } catch (e) {
//       debugPrint("Error uploading image: $e");
//     }

//         // Create status with the image URL
//         await addImageStatus(
//           _auth.currentUser?.uid ?? 'unknown',
//           _auth.currentUser?.displayName ?? 'User',
//           downloadUrl
//         );
//       } catch (e) {
//         debugPrint("Error processing image: $e");
//       } finally {
//         _isLoading = false;
//         notifyListeners();
//       }
//     }
//   }
//   }

//   // Upload image to Firebase Storage
//   Future<String> _uploadImageToStorage(File imageFile) async {
//     final user = _auth.currentUser;
//     if (user == null) throw Exception("User not authenticated");

//     // Create unique reference with timestamp
//     String fileName = '${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
//     Reference ref = _storage.ref().child('status_images').child(fileName);

//     // Upload file
//     UploadTask uploadTask = ref.putFile(imageFile);
//     TaskSnapshot snapshot = await uploadTask;
//     return await snapshot.ref.getDownloadURL();
//   }

//   // Fetch all statuses from Firestore
//   Future<void> fetchStatuses() async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       final snapshot = await _firestore
//           .collection('statuses')
//           .orderBy('timestamp', descending: true)
//           .get();

//       _statuses = snapshot.docs
//           .map((doc) => StatusModel.fromMap(doc.data()))
//           .toList();
//     } catch (e) {
//       debugPrint("Error fetching statuses: $e");
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // Add text status
//   Future<void> addTextStatus(String text, String color) async {
//     final user = _auth.currentUser;
//     if (user == null) return;

//     _isLoading = true;
//     notifyListeners();

//     try {
//       final statusId = _firestore.collection('statuses').doc().id;
//       final status = StatusModel(
//         statusId: statusId,
//         userId: user.uid,
//         username: user.displayName ?? 'User',
//         statusType: StatusType.text,
//         textContent: text,
//         color: color,
//         timestamp: DateTime.now(),
//         viewedBy: [],
//       );

//       await _firestore
//           .collection('statuses')
//           .doc(statusId)
//           .set(status.toMap());

//       await fetchStatuses(); // Refresh the list
//     } catch (e) {
//       debugPrint("Error adding text status: $e");
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // Add image status
//   Future<void> addImageStatus(String userId, String username, String imageUrl) async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       final statusId = _firestore.collection('statuses').doc().id;
//       final status = StatusModel(
//         statusId: statusId,
//         userId: userId,
//         username: username,
//         statusType: StatusType.image,
//         mediaUrl: imageUrl,
//         textContent: "Image",
//         timestamp: DateTime.now(),
//         viewedBy: [],
//       );

//       await _firestore
//           .collection('statuses')
//           .doc(statusId)
//           .set(status.toMap());

//       await fetchStatuses(); // Refresh the list
//     } catch (e) {
//       debugPrint("Error adding image status: $e");
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // Mark status as viewed
//   Future<void> markStatusAsViewed(String statusId) async {
//     final currentUser = _auth.currentUser;
//     if (currentUser == null) return;

//     try {
//       final docRef = _firestore.collection('statuses').doc(statusId);
//       final doc = await docRef.get();

//       if (doc.exists) {
//         final statusData = doc.data() as Map<String, dynamic>;
//         List<String> viewedBy = List<String>.from(statusData['viewedBy'] ?? []);

//         if (!viewedBy.contains(currentUser.uid)) {
//           viewedBy.add(currentUser.uid);
//           await docRef.update({'viewedBy': viewedBy});

//           // Update local state if the status is in our list
//           int index = _statuses.indexWhere((s) => s.statusId == statusId);
//           if (index != -1) {
//             _statuses[index].viewedBy.add(currentUser.uid);
//             notifyListeners();
//           }
//         }
//       }
//     } catch (e) {
//       debugPrint('Error marking status as viewed: $e');
//     }
//   }

//   // Check if current user has any status
//   bool hasStatus() {
//     final currentUser = _auth.currentUser;
//     if (currentUser == null) return false;

//     return _statuses.any((status) =>
//       status.userId == currentUser.uid &&
//       status.timestamp != null &&
//       status.timestamp!.isAfter(DateTime.now().subtract(Duration(hours: 24)))
//     );
//   }
// }

class StatusProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  List<StatusModel> _statuses = [];
  bool _isLoading = false;
  late String _userId;

  List<StatusModel> get statuses => _statuses;
  bool get isLoading => _isLoading;
  String get userId => _userId;

  StatusProvider() {
    _init();
  }

  Future<void> _init() async {
    await fetchStatuses();
  }

  Future<void> selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _isLoading = true;
      notifyListeners();

      try {
        final File imageFile = File(pickedFile.path);
        final imageUrl = await _uploadImageToStorage(imageFile);

        final user = _auth.currentUser;
        if (user != null) {
          final statusId = _firestore.collection('statuses').doc().id;
          final status = StatusModel(
            statusId: statusId,
            userId: user.uid,
            username: user.displayName ?? 'User',
            statusType: StatusType.image,
            mediaUrl: imageUrl,
            textContent: "Image",
            timestamp: DateTime.now(),
            viewedBy: [],
          );

          await _firestore
              .collection('statuses')
              .doc(statusId)
              .set(status.toMap());
          _statuses.insert(0, status); // insert to top
        }
      } catch (e) {
        debugPrint("Error uploading image status: $e");
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<String> _uploadImageToStorage(File imageFile) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not authenticated");

    String fileName =
        '${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    Reference ref = _storage.ref().child('status_images').child(fileName);

    UploadTask uploadTask = ref.putFile(imageFile);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> fetchStatuses() async {
    
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return;

      final timestampLimit = DateTime.now().subtract(const Duration(hours: 24));

      // Fetch statuses from Firestore
      final snapshot = await _firestore
          .collection('statuses')
          .where('timestamp',
              isGreaterThan: timestampLimit) // Only fetch recent statuses
          .orderBy('timestamp', descending: true)
          .get();

      // Map Firestore data to StatusModel and filter out the current user's own statuses
      _statuses = snapshot.docs
          .map((doc) => StatusModel.fromMap(doc.data()))
          .where((status) =>
              status.userId !=
              currentUser
                  .uid) // Exclude current user's statuses from recent updates
          .toList();

      // Optionally, you can fetch the current user's own statuses separately for "My Status" if needed
      final myStatusesSnapshot = await _firestore
          .collection('statuses')
          .where('userId', isEqualTo: currentUser.uid)
          .where('timestamp', isGreaterThan: timestampLimit)
          .orderBy('timestamp', descending: true)
          .get();

      // Add current user's statuses to the beginning of the list (to show as "My Status")
      final myStatuses = myStatusesSnapshot.docs
          .map((doc) => StatusModel.fromMap(doc.data()))
          .toList();

      _statuses.insertAll(
          0, myStatuses); // Insert "My Status" at the top of the list
    } catch (e) {
      debugPrint("Error fetching statuses: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTextStatus(String text, String color) async {
    final user = _auth.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final statusId = _firestore.collection('statuses').doc().id;
      final status = StatusModel(
        statusId: statusId,
        userId: user.uid,
        username: user.displayName ?? 'User',
        statusType: StatusType.text,
        textContent: text,
        color: color,
        timestamp: DateTime.now(),
        viewedBy: [],
      );

      await _firestore.collection('statuses').doc(statusId).set(status.toMap());
      _statuses.insert(0, status); // insert new status at top
    } catch (e) {
      debugPrint("Error adding text status: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markStatusAsViewed(String statusId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      final docRef = _firestore.collection('statuses').doc(statusId);
      final doc = await docRef.get();

      if (doc.exists) {
        final statusData = doc.data() as Map<String, dynamic>;
        List<String> viewedBy = List<String>.from(statusData['viewedBy'] ?? []);

        if (!viewedBy.contains(currentUser.uid)) {
          viewedBy.add(currentUser.uid);
          await docRef.update({'viewedBy': viewedBy});

          int index = _statuses.indexWhere((s) => s.statusId == statusId);
          if (index != -1) {
            _statuses[index].viewedBy.add(currentUser.uid);
            notifyListeners();
          }
        }
      }
    } catch (e) {
      debugPrint('Error marking status as viewed: $e');
    }
  }

  bool hasStatus() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return false;

    return _statuses.any((status) =>
        status.userId == currentUser.uid &&
        status.timestamp != null &&
        status.timestamp!
            .isAfter(DateTime.now().subtract(Duration(hours: 24))));
  }
}
