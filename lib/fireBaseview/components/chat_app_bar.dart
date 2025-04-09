import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/fireBaseController/contact_provider.dart';
import 'package:wtsp_clone/fireBaseController/onetoone_chat_provider.dart';
import 'package:wtsp_clone/fireBasemodel/models/profile_image_helper.dart';
import 'package:wtsp_clone/fireBasemodel/models/user_model.dart';
import 'package:wtsp_clone/fireBaseview/screens/chats/contact_profile_screen.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final UserModel user;
  final VoidCallback onCancelSelection;

  const ChatAppBar({
    super.key,
    required this.user,
    required this.onCancelSelection,
  });

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<FireBaseContactsProvider>(context);
    return Consumer<FireBaseOnetoonechatProvider>(
      builder: (context, provider, _) {
        final selectionActive = provider.isSelectionMode;
        String chatId = chatProvider.getChatId(user.uid);
        return AppBar(
          titleSpacing: 0,
          scrolledUnderElevation: 0,
          leadingWidth: 40,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: selectionActive
                ? onCancelSelection
                : () => Navigator.pop(context),
          ),
          title: selectionActive
              ? Text(
                  "${provider.selectedMessageIds.length} selected",
                  style: TextStyle(color: Colors.black),
                )
              : Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ContactProfileScreen(user: user),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.blueGrey,
                        backgroundImage: user.photoURL.isNotEmpty
                            ? NetworkImage(user.photoURL)
                            : AssetImage(ProfileImageHelper.getProfileImage(
                                user.phone)) as ImageProvider,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.uid == FirebaseAuth.instance.currentUser?.uid
                              ? '${user.firstName} (You)'
                              : user.firstName,
                          style: TextStyle(
                              fontSize: 18.5, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          provider.lastSeen,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
          actions: selectionActive
              ? [
                  IconButton(
                      icon: Icon(Icons.star_border, color: Colors.black),
                      onPressed: () {}),
                  IconButton(
                      icon: Icon(Icons.reply_outlined, color: Colors.black),
                      onPressed: () {}),
                  IconButton(
                      icon: Icon(Icons.forward, color: Colors.black),
                      onPressed: () {}),
                  deleteIconButton(
                      context,
                      Provider.of<FireBaseOnetoonechatProvider>(context,
                          listen: false),
                      chatId),
                ]
              : [
                  IconButton(onPressed: () {}, icon: Icon(Icons.video_call)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.call)),
                  popUpMenu(),
                ],
          backgroundColor: Colors.white,
        );
      },
    );
  }

  IconButton deleteIconButton(BuildContext context,
      FireBaseOnetoonechatProvider provider, String chatId) {
    return IconButton(
      icon: Icon(Icons.delete, color: Colors.black),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Delete Messages"),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context); // Close dialog
                  await provider.deleteMessagesForEveryone(
                    provider.selectedMessageIds, // List<String>
                    chatId,
                  );
                },
                child: Text(
                  "Delete for Everyone",
                  style: TextStyle(color: Color.fromARGB(255, 69, 169, 94)),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context); // Close dialog

                  await provider.deleteMessagesForMe(
                    provider.selectedMessageIds, // List<String>
                    chatId,
                  );
                },
                child: Text(
                  "Delete for Me",
                  style: TextStyle(color: Color.fromARGB(255, 69, 169, 94)),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Color.fromARGB(255, 69, 169, 94)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  PopupMenuButton<String> popUpMenu() {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert),
      onSelected: (value) => (),
      itemBuilder: (context) => [
        PopupMenuItem(value: "Search", child: Text("Search")),
        PopupMenuItem(value: "Add to List", child: Text("Add to List")),
        PopupMenuItem(value: "Media", child: Text("Media, Links, and Docs")),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
