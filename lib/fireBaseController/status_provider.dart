import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wtsp_clone/fireBasemodel/models/status_model.dart';

class StatusProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  List<StatusModel> _statuses = [];
  bool _isLoading = false;
  String? _userId;

  List<StatusModel> get statuses => _statuses;
  bool get isLoading => _isLoading;
  String? get userId => _userId;

  StatusProvider() {
    _init();
  }

  Future<void> _init() async {
    _userId = _auth.currentUser?.uid;
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
            color: null,
            timestamp: DateTime.now(),
            viewedBy: [],
          );

          await _firestore
              .collection('statuses')
              .doc(statusId)
              .set(status.toMap());
          _statuses.insert(statuses.length+1, status); 
          await fetchStatuses();
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
    _isLoading = true;
    notifyListeners();
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

  Future<void> addTextStatus(String text, dynamic color) async {
    final user = _auth.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Convert color to string if it's not already
      String colorStr;
      if (color is Color) {
        colorStr = '#${color.value.toRadixString(16).padLeft(8, '0')}';
      } else {
        colorStr = color.toString();
      }

      final statusId = _firestore.collection('statuses').doc().id;
      final status = StatusModel(
        statusId: statusId,
        userId: user.uid,
        username: user.displayName ?? 'User',
        statusType: StatusType.text,
        textContent: text,
        color: colorStr,
        timestamp: DateTime.now(),
        viewedBy: [],
      );

      await _firestore.collection('statuses').doc(statusId).set(status.toMap());
      _statuses.insert(statuses.length+1, status); 
      await fetchStatuses();
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

          //int index = _statuses.indexWhere((s) => s.statusId == statusId);
          // if (index != -1) {
          //   _statuses[index].viewedBy.add(currentUser.uid);
          //   notifyListeners();
          // }
          await fetchStatuses();
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

