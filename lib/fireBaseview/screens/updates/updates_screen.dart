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

// class FireBaseUpdatesScreen extends StatelessWidget {
//   const FireBaseUpdatesScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final statusProvider = Provider.of<StatusProvider>(context);

//     return Scaffold(
//       appBar: _buildAppBar(),
//       body: statusProvider.isLoading
//         ? Center(child: CircularProgressIndicator())
//         : _buildBody(context, statusProvider),
//       floatingActionButton: _buildFloatingActions(context, statusProvider),
//     );
//   }

//   AppBar _buildAppBar() {
//     return AppBar(
//       title: Text(
//         "Updates",
//         style: TextStyle(
//           fontWeight: FontWeight.bold,
//           fontSize: 22,
//           color: Color.fromARGB(255, 108, 193, 149),
//         ),
//       ),
//       backgroundColor: Colors.white,
//       actions: [
//         IconButton(
//           icon: Icon(Icons.search, color: Colors.black),
//           onPressed: () {},
//         ),
//         PopupMenuButton<String>(
//           icon: Icon(Icons.more_vert, color: Colors.black),
//           itemBuilder: (BuildContext context) {
//             return [
//               PopupMenuItem<String>(
//                 value: "Settings",
//                 child: Text("Settings"),
//               ),
//             ];
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildBody(BuildContext context, StatusProvider statusProvider) {
//     // Get current user
//     final currentUser = FirebaseAuth.instance.currentUser;

//     // Separate user's statuses from others
//     final myStatuses = statusProvider.statuses
//         .where((s) => s.userId == currentUser?.uid)
//         .toList();

//     // Get other users' statuses
//     final otherStatuses = statusProvider.statuses
//         .where((s) => s.userId != currentUser?.uid)
//         .toList();

//     // Separate viewed and unviewed statuses
//     final recentUpdates = otherStatuses
//         .where((s) => !(s.viewedBy.contains(currentUser?.uid)))
//         .toList();

//     final viewedUpdates = otherStatuses
//         .where((s) => s.viewedBy.contains(currentUser?.uid))
//         .toList();

//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // My Status Section
//           ListTile(
//             leading: ProfileAvataar(
//               image: statusProvider.profileImage,
//               onSelectImage: () => statusProvider.selectImage(),
//               hasStatus: statusProvider.hasStatus(),
//             ),
//             title: const Text(
//               "My Status",
//               style: TextStyle(fontWeight: FontWeight.bold)
//             ),
//             subtitle: Text(
//               myStatuses.isNotEmpty
//                 ? "Tap to view your status"
//                 : "Tap to add status update"
//             ),
//             onTap: () {
//               if (myStatuses.isNotEmpty) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => StatusViewerScreen(
//                       statuses: myStatuses,
//                     ),
//                   ),
//                 );
//               } else {
//                 // Show bottom sheet with options to add status
//                 _showAddStatusOptions(context, statusProvider);
//               }
//             },
//           ),

//           // Recent Updates Section
//           if (recentUpdates.isNotEmpty) ...[
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               child: const Text(
//                 "Recent Updates",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
//               ),
//             ),
//             ...recentUpdates.map((status) => StatusTile(
//               imagePath: status.mediaUrl ?? "assets/images/placeholder.jpg",
//               name: status.username,
//               subtitle: _getTimeAgo(status.timestamp),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => StatusViewerScreen(
//                       statuses: [status],
//                       onStatusViewed: (statusId) {
//                         statusProvider.markStatusAsViewed(statusId);
//                       },
//                     ),
//                   ),
//                 );
//               },
//             )),
//           ],

//           // Viewed Updates Section
//           if (viewedUpdates.isNotEmpty) ...[
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               child: const Text(
//                 "Viewed Updates",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
//               ),
//             ),
//             ...viewedUpdates.map((status) => StatusTile(
//               imagePath: status.mediaUrl ?? "assets/images/placeholder.jpg",
//               name: status.username,
//               subtitle: _getTimeAgo(status.timestamp),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => StatusViewerScreen(
//                       statuses: [status],
//                     ),
//                   ),
//                 );
//               },
//             )),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildFloatingActions(BuildContext context, StatusProvider statusProvider) {
//     return FloatingActions(
//       onTextStatus: () async {
//         final result = await Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => TextStatusScreen()),
//         );

//         if (result != null && result is Map<String, dynamic>) {
//           // Pass the text and color from the TextStatusScreen
//           statusProvider.addTextStatus(
//             result['text'],
//             result['color']
//           );
//         }
//       },
//       onImageStatus: () => statusProvider.selectImage(),
//     );
//   }

//   void _showAddStatusOptions(BuildContext context, StatusProvider statusProvider) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           ListTile(
//             leading: Icon(Icons.text_fields),
//             title: Text("Text Status"),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => TextStatusScreen()),
//               ).then((result) {
//                 if (result != null && result is Map<String, dynamic>) {
//                   statusProvider.addTextStatus(result['text'], result['color']);
//                 }
//               });
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.photo),
//             title: Text("Image Status"),
//             onTap: () {
//               Navigator.pop(context);
//               statusProvider.selectImage();
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   String _getTimeAgo(DateTime? timestamp) {
//     if (timestamp == null) return "Unknown";

//     final now = DateTime.now();
//     final difference = now.difference(timestamp);

//     if (difference.inSeconds < 60) {
//       return "Just now";
//     } else if (difference.inMinutes < 60) {
//       return "${difference.inMinutes}m ago";
//     } else if (difference.inHours < 24) {
//       return "${difference.inHours}h ago";
//     } else {
//       return "${difference.inDays}d ago";
//     }
//   }
// }

// class UpdatesScreen extends StatefulWidget {
//   const UpdatesScreen({super.key});
//   @override
//   _UpdatesScreenState createState() => _UpdatesScreenState();
// }

// class _UpdatesScreenState extends State<UpdatesScreen> {
//   final List<Map<String, dynamic>> _statuses = [];
//   void selectImage() async {
//     Uint8List img = await pickImage(ImageSource.gallery);
//     setState(() {
//       _statuses.add({'type': 'image', 'content': img});
//     });
//   }

//   void _uploadTextStatus(Map<String, dynamic> status) {
//     setState(() {
//       _statuses.add({
//         'type': 'text',
//         'content': status['text'],
//         'color': status['color']
//       });
//     });
//   }

//   void _viewStatuses() {
//     if (_statuses.isNotEmpty) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => StatusViewerScreen(statuses: _statuses)),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: updateScreenAppBar(),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ListTile(
//               leading: ProfileAvataar(
//                   //image: _image,
//                   onSelectImage: selectImage,
//                   hasStatus: _statuses.isNotEmpty),
//               title: const Text("My Status",
//                   style: TextStyle(fontWeight: FontWeight.bold)),
//               subtitle: const Text("Tap to add status update"),
//               onTap: _viewStatuses,
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               child: const Text("Recent Updates",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             ),
//             StatusTile(
//               imagePath: "assets/images/contact1.jpg",
//               name: "John Doe",
//               subtitle: "Just now",
//               onTap: () {},
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               child: const Text("Viewed Updates",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             ),
//             StatusTile(
//                 imagePath: "assets/images/contact3.jpg",
//                 name: "Jane Smith",
//                 subtitle: "1 hour ago",
//                 onTap: () {}),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActions(
//         onTextStatus: () async {
//           final result = await Navigator.push(context,
//               MaterialPageRoute(builder: (context) => TextStatusScreen()));
//           if (result != null && result is Map<String, dynamic>) {
//             _uploadTextStatus(result);
//           }
//         },
//         onImageStatus: selectImage,
//       ),
//     );
//   }

//   AppBar updateScreenAppBar() {
//     return AppBar(
//       title: Text(
//         "Updates",
//         style: TextStyle(
//           fontWeight: FontWeight.bold,
//           fontSize: 22,
//           color:Color.fromARGB(255, 108, 193, 149),
//         ),
//       ),
//       backgroundColor: Colors.white,
//       actions: [
//         IconButton(
//           icon: Icon(Icons.search, color: Colors.black),
//           onPressed: () {},
//         ),
//         PopupMenuButton<String>(
//           icon: Icon(Icons.more_vert, color: Colors.black),
//           itemBuilder: (BuildContext context) {
//             return [
//               PopupMenuItem<String>(
//                 value: "Settings",
//                 child: Text("Settings"),
//               ),
//             ];
//           },
//         ),
//       ],
//     );
//   }
// }

class UpdatesScreen extends StatelessWidget {
  const UpdatesScreen({Key? key}) : super(key: key);

  void _viewStatuses(BuildContext context, List<StatusModel> statuses) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StatusViewerScreen(statuses: statuses),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusProvider = Provider.of<StatusProvider>(context);
    if (statusProvider.statuses.isEmpty && !statusProvider.isLoading) {
      statusProvider.fetchStatuses();
    }
    final hasMyStatus = statusProvider.hasStatus();

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
                    subtitle: const Text("Tap to add status update"),
                    onTap: () {
                      final myStatuses = statusProvider.statuses
                          .where((s) =>
                              s.userId ==
                              FirebaseAuth.instance.currentUser?.uid)
                          .toList();
                      if (myStatuses.isNotEmpty) {
                        _viewStatuses(context, myStatuses);
                      }
                    },
                  ),
                  if (statusProvider.statuses.any((s) =>
                      s.userId != FirebaseAuth.instance.currentUser?.uid &&
                      !s.viewedBy.contains(
                          FirebaseAuth.instance.currentUser?.uid))) ...[
                    _sectionTitle("Recent Updates"),
                    ...statusProvider.statuses
                        .where((s) =>
                            s.userId !=
                                FirebaseAuth.instance.currentUser?.uid &&
                            !s.viewedBy.contains(
                                FirebaseAuth.instance.currentUser?.uid))
                        .map((status) => StatusTile(
                              imageUrl: status.mediaUrl!,
                              name: status.username,
                              subtitle: timeAgo(status.timestamp!),
                              onTap: () {
                                statusProvider
                                    .markStatusAsViewed(status.statusId);
                                _viewStatuses(
                                  context,
                                  statusProvider.statuses
                                      .where((s) => s.userId == status.userId)
                                      .toList(),
                                );
                              },
                            ))
                  ],
                  if (statusProvider.statuses.any((s) =>
                      s.userId != FirebaseAuth.instance.currentUser?.uid &&
                      s.viewedBy.contains(
                          FirebaseAuth.instance.currentUser?.uid))) ...[
                    _sectionTitle("Viewed Updates"),
                    ...statusProvider.statuses
                        .where((s) =>
                            s.userId !=
                                FirebaseAuth.instance.currentUser?.uid &&
                            s.viewedBy.contains(
                                FirebaseAuth.instance.currentUser?.uid))
                        .map((status) => StatusTile(
                              imageUrl: status.mediaUrl!,
                              name: status.username,
                              subtitle: timeAgo(status.timestamp!),
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

  Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      );

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
}
