import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/fireBaseController/status_provider.dart';
import 'package:wtsp_clone/fireBasemodel/models/status_model.dart';
import 'package:wtsp_clone/fireBaseview/components/profileAvatar.dart';
import 'package:wtsp_clone/fireBaseview/components/status_tile.dart';
import 'package:wtsp_clone/fireBaseview/screens/updates/status_viewer_screen.dart';
import 'package:wtsp_clone/view/screens/updates/text_status_screen.dart';
import 'package:wtsp_clone/view/components/floating_actions.dart';

class FireBaseUpdatesScreen extends StatelessWidget {
  const FireBaseUpdatesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusProvider = Provider.of<StatusProvider>(context);
    // if (statusProvider.statuses.isEmpty && !statusProvider.isLoading) {
    //   statusProvider.fetchStatuses();
    // }
    final hasMyStatus = statusProvider.hasStatus();
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    // Group statuses by user
    Map<String, StatusModel> userStatuses = {};
    for (var status in statusProvider.statuses) {
      if (status.userId != currentUserId) {
        // Only keep the most recent status per user
        if (!userStatuses.containsKey(status.userId) || 
            (status.timestamp != null && userStatuses[status.userId]!.timestamp != null && 
             status.timestamp!.isAfter(userStatuses[status.userId]!.timestamp!))) {
          userStatuses[status.userId] = status;
        }
      }
    }
    // Separate statuses into viewed and unviewed
    final unviewedStatuses = userStatuses.values
        .where((s) => !s.viewedBy.contains(currentUserId))
        .toList();
    
    final viewedStatuses = userStatuses.values
        .where((s) => s.viewedBy.contains(currentUserId))
        .toList();

    return Scaffold(
      appBar: updateScreenAppBar(),
      body: statusProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: ProfileAvataar(
                      onSelectImage: () => statusProvider.selectImage(),
                      hasStatus: hasMyStatus,
                    ),
                    title: const Text("My Status",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: hasMyStatus 
                        ? const Text("Tap to view status")
                        : const Text("Tap to add status"),
                    onTap: () {
                      if (hasMyStatus) {
                        final myStatuses = statusProvider.statuses
                            .where((s) => s.userId == currentUserId)
                            .toList();
                        if (myStatuses.isNotEmpty) {
                          _viewStatuses(context, myStatuses);
                        }
                      } else {
                        statusProvider.selectImage();
                      }
                    },
                  ),
                  
                  if (unviewedStatuses.isNotEmpty) ...[
                    _sectionTitle("Recent Updates"),
                    ...unviewedStatuses.map((status) => StatusTile(
                          imageUrl: status.mediaUrl ?? '',
                          name: status.username,
                          subtitle: status.timestamp != null
                              ? timeAgo(status.timestamp!)
                              : 'Unknown time',
                          isViewed: false,
                          onTap: () {
                            statusProvider.markStatusAsViewed(status.statusId);
                            _viewStatuses(
                              context,
                              statusProvider.statuses
                                  .where((s) => s.userId == status.userId)
                                  .toList(),
                            );
                          },
                        ))
                  ],
                  
                  if (viewedStatuses.isNotEmpty) ...[
                    _sectionTitle("Viewed Updates"),
                    ...viewedStatuses.map((status) => StatusTile(
                          imageUrl: status.mediaUrl ?? '',
                          name: status.username,
                          subtitle: status.timestamp != null
                              ? timeAgo(status.timestamp!)
                              : 'Unknown time',
                          isViewed: true,
                          onTap: () {
                            _viewStatuses(
                              context,
                              statusProvider.statuses
                                  .where((s) => s.userId == status.userId)
                                  .toList(),
                            );
                          },
                        ))
                  ],
                ],
              ),
            ),
      floatingActionButton: FloatingActions(
        onTextStatus: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TextStatusScreen()),
          );
          if (result != null && result is Map<String, dynamic>) {
            await statusProvider.addTextStatus(result['text'], result['color']);
          }
        },
        onImageStatus: () => statusProvider.selectImage(),
      ),
    );
  }

  void _viewStatuses(BuildContext context, List<StatusModel> statuses) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StatusViewerScreen(statuses: statuses),
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      );
}

AppBar updateScreenAppBar() {
    return AppBar(
      title: const Text(
        "Updates",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Color.fromARGB(255, 108, 193, 149),
        ),
      ),
      backgroundColor: Colors.white,
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black),
          onPressed: () {},
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.black),
          itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem<String>(
                value: "Settings",
                child: Text("Settings"),
              ),
            ];
          },
        ),
      ],
    );
  }

  String timeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    if (diff.inMinutes < 60) return "${diff.inMinutes} minutes ago";
    if (diff.inHours < 24) return "${diff.inHours} hours ago";
    return "${diff.inDays} days ago";
  }

