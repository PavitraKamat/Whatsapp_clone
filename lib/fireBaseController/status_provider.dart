import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wtsp_clone/fireBasemodel/models/status_model.dart';
import 'package:wtsp_clone/fireBasemodel/models/user_model.dart';

class StatusProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  List<StatusModel> _statuses = [];
  Map<String, UserModel> _userProfiles = {};
  bool _isLoading = false;
  String? _userId;

  List<StatusModel> get statuses => _statuses;
  Map<String, UserModel> get userProfiles => _userProfiles;
  bool get isLoading => _isLoading;
  String? get userId => _userId;

  StatusProvider() {
    _init();
  }

  Future<void> _init() async {
    _userId = _auth.currentUser?.uid;
    await cleanupExpiredStatuses();
    await fetchStatuses();
  }

  Future<void> selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _isLoading = true;
      notifyListeners();

      try {
        await cleanupExpiredStatuses();

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

  Future<void> fetchUserProfile(String userId) async {
  if (_userProfiles.containsKey(userId)) return;

  final doc = await _firestore.collection('users').doc(userId).get();
  if (doc.exists) {
    _userProfiles[userId] = UserModel.fromMap(doc.data()!);
    notifyListeners();
  }
  }

  UserModel? getUser(String userId) => _userProfiles[userId];

  Future<void> fetchStatuses() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Clean up expired statuses when fetching
      await cleanupExpiredStatuses();

      final currentUser = _auth.currentUser;
      if (currentUser == null) return;

      final timestampLimit = DateTime.now().subtract(const Duration(hours: 24));

      // Create a map to store unique statuses by user
      Map<String, List<StatusModel>> userStatuses = {};

      // Fetch all statuses from Firestore
      final snapshot = await _firestore
          .collection('statuses')
          .where('timestamp', isGreaterThan: Timestamp.fromDate(timestampLimit))
          .orderBy('timestamp', descending: true)
          .get();

      // Group statuses by user
      for (var doc in snapshot.docs) {
        final status = StatusModel.fromMap(doc.data());
        if (!userStatuses.containsKey(status.userId)) {
          userStatuses[status.userId] = [];
        }
        userStatuses[status.userId]!.add(status);
      }

      // Clear existing statuses
      _statuses = [];
      await Future.wait(userStatuses.keys.map(fetchUserProfile));
      // Add current user's statuses first if they exist
      if (userStatuses.containsKey(currentUser.uid)) {
        _statuses.addAll(userStatuses[currentUser.uid]!);
        // Remove current user from the map so we don't add them again
        userStatuses.remove(currentUser.uid);
      }

      // Add all other users' statuses
      for (var userStatusList in userStatuses.values) {
        _statuses.addAll(userStatusList);
      }
      
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
      await cleanupExpiredStatuses();
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

  Future<void> cleanupExpiredStatuses() async {
    try {
      final currentTime = DateTime.now();
      final cutoffTime = currentTime.subtract(const Duration(hours: 24));

      // Get all expired statuses
      final expiredStatusesSnapshot = await _firestore
          .collection('statuses')
          .where('timestamp', isLessThan: Timestamp.fromDate(cutoffTime))
          .get();

      if (expiredStatusesSnapshot.docs.isEmpty) {
        debugPrint("No expired statuses found");
        return;
      }

      debugPrint(
          "Found ${expiredStatusesSnapshot.docs.length} expired statuses to delete");

      // Batch delete for efficiency
      final batch = _firestore.batch();

      // Track image URLs that need to be deleted from storage
      List<String> imageUrlsToDelete = [];

      for (var doc in expiredStatusesSnapshot.docs) {
        final statusData = doc.data();
        if (statusData['statusType'] == 'image' &&
            statusData['mediaUrl'] != null) {
          final String mediaUrl = statusData['mediaUrl'];
          if (mediaUrl.isNotEmpty) {
            imageUrlsToDelete.add(mediaUrl);
          }
        }
        batch.delete(doc.reference);
      }

      // Execute the batch delete
      await batch.commit();

      // Delete images from Firebase Storage
      for (var url in imageUrlsToDelete) {
        try {
          // Extract the path from the URL
          final uri = Uri.parse(url);
          final path = Uri.decodeFull(uri.path);
          final startIndex = path.indexOf('/o/') + 3; // +3 to skip '/o/'
          final endIndex = path.indexOf('?', startIndex);
          final storagePath = endIndex != -1
              ? path.substring(startIndex, endIndex)
              : path.substring(startIndex);

          // Create a reference to the file and delete it
          final ref = _storage.ref().child(storagePath);
          await ref.delete();
          debugPrint("Deleted image: $storagePath");
        } catch (e) {
          debugPrint("Error deleting image from storage: $e");
        }
      }

      debugPrint(
          "Successfully cleaned up ${expiredStatusesSnapshot.docs.length} expired statuses");

      // Refresh the statuses list
      await fetchStatuses();
    } catch (e) {
      debugPrint("Error cleaning up expired statuses: $e");
    }
  }
}

