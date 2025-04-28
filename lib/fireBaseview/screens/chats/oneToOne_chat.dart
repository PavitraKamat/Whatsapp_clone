import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/fireBaseController/onetoone_chat_provider.dart';
import 'package:wtsp_clone/fireBasemodel/models/user_model.dart';
import 'package:wtsp_clone/fireBaseview/components/chat_app_bar.dart';
import 'package:wtsp_clone/fireBaseview/components/input_field.dart';
import 'package:wtsp_clone/fireBaseview/components/messageBubble_component/message_bubble.dart';
import 'package:wtsp_clone/fireBaseview/components/type_indicator.dart';

class FireBaseOnetooneChat extends StatelessWidget {
  final UserModel user;

  const FireBaseOnetooneChat({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        var provider = FireBaseOnetoonechatProvider(user: user);
        provider.openChat(FirebaseAuth.instance.currentUser!.uid, user.uid);
        return provider;
      },
      child: Builder(builder: (context) {
        return _FireBaseOnetooneChatScreen(user: user);
      }),
    );
  }
}

class _FireBaseOnetooneChatScreen extends StatelessWidget {
  final UserModel user;
  const _FireBaseOnetooneChatScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<FireBaseOnetoonechatProvider>(context);
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    return Stack(
      children: [
        chatScreenBackgroundImage(context),
        Scaffold(
            backgroundColor: Colors.transparent,
            appBar: ChatAppBar(
              user: user,
              onCancelSelection: () {
                chatProvider.clearSelection();
              },
            ),
            body: _buildChatBody(chatProvider, currentUserId)),
      ],
    );
  }

  Column _buildChatBody(
      FireBaseOnetoonechatProvider chatProvider, String currentUserId) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (chatProvider.scrollController.hasClients) {
    //     chatProvider.scrollController
    //         .jumpTo(chatProvider.scrollController.position.maxScrollExtent);
    //   }
    // });
    chatProvider.scrollToBottom();
    return Column(
      children: [
        Expanded(child: KeyboardVisibilityBuilder(
          builder: (context, isKeyboardVisible) {
            if (isKeyboardVisible) {
              // Delay to allow keyboard animation
              Future.delayed(Duration(milliseconds: 100), () {
                chatProvider.scrollToBottom();
              });
            }
            return ListView.builder(
              controller: chatProvider.scrollController,
              padding: EdgeInsets.symmetric(vertical: 8),
              itemCount: chatProvider.messages.length +
                  (chatProvider.isReceiverTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (chatProvider.isReceiverTyping &&
                    index == chatProvider.messages.length) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: TypeIndicator(),
                    ),
                  );
                }
                final message = chatProvider.messages[index];
                final isSentByMe = message.senderId == currentUserId;
                return Align(
                  alignment:
                      isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
                  child:
                      MessageBubble(message: message, isSentByMe: isSentByMe),
                );
              },
            );
          },
        )),
        MessageInputField(
          //controller: chatProvider.messageController,
          senderId: currentUserId,
          receiverId: user.uid,
          onSend: () async {
            String messageText = chatProvider.messageController.text.trim();

            if (messageText.isNotEmpty) {
              await chatProvider.sendMessage(
                senderId: currentUserId,
                receiverId: user.uid,
                text: messageText,
              );

              chatProvider.messageController.clear();
              chatProvider.scrollToBottom();
            }
          },
        ),
      ],
    );
  }

  Image chatScreenBackgroundImage(BuildContext context) {
    return Image.asset(
      "assets/images/whatsapp_background.png",
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.cover,
    );
  }
}


//------------------------------------------------------------------------------

// class FireBaseOnetooneChat extends StatelessWidget {
//   final UserModel user;

//   const FireBaseOnetooneChat({super.key, required this.user});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         // Create all required providers
//         ChangeNotifierProvider(create: (_) => MessageProvider()),
//         ChangeNotifierProvider(create: (_) => UserStatusProvider()),
//         ChangeNotifierProvider(create: (_) => ChatUIProvider(user: user)),
//         // Coordinator that connects all providers
//         ChangeNotifierProxyProvider3<MessageProvider, UserStatusProvider, ChatUIProvider, ChatCoordinator>(
//           create: (context) => ChatCoordinator(
//             messageProvider: context.read<MessageProvider>(),
//             userStatusProvider: context.read<UserStatusProvider>(),
//             chatUIProvider: context.read<ChatUIProvider>(),
//             receiver: user,
//           ),
//           update: (context, messageProvider, userStatusProvider, chatUIProvider, previous) {
//             return previous ?? ChatCoordinator(
//               messageProvider: messageProvider,
//               userStatusProvider: userStatusProvider,
//               chatUIProvider: chatUIProvider,
//               receiver: user,
//             );
//           },
//         ),
//       ],
//       child: Builder(builder: (context) {
//         return _FireBaseOnetooneChatScreen(user: user);
//       }),
//     );
//   }
// }

// class _FireBaseOnetooneChatScreen extends StatelessWidget {
//   final UserModel user;
//   const _FireBaseOnetooneChatScreen({required this.user});

//   @override
//   Widget build(BuildContext context) {
//     // Access all providers
//     final messageProvider = Provider.of<MessageProvider>(context);
//     final userStatusProvider = Provider.of<UserStatusProvider>(context);
//     final chatUIProvider = Provider.of<ChatUIProvider>(context);
//     final coordinator = Provider.of<ChatCoordinator>(context);
    
//     final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    
//     return Stack(
//       children: [
//         chatScreenBackgroundImage(context),
//         Scaffold(
//           backgroundColor: Colors.transparent,
//           appBar: ChatAppBar(
//             user: user,
//             //isSelectionMode: chatUIProvider.isSelectionMode,
//             //lastSeen: userStatusProvider.lastSeen,
//             onCancelSelection: () {
//               chatUIProvider.clearSelection();
//             },
//           ),
//           body: _buildChatBody(
//             messageProvider, 
//             userStatusProvider, 
//             chatUIProvider, 
//             coordinator, 
//             currentUserId
//           ),
//         ),
//       ],
//     );
//   }

//   Column _buildChatBody(
//     MessageProvider messageProvider,
//     UserStatusProvider userStatusProvider,
//     ChatUIProvider chatUIProvider,
//     ChatCoordinator coordinator,
//     String currentUserId) {
    
//     // Scroll to bottom when needed
//     chatUIProvider.scrollToBottom();
    
//     return Column(
//       children: [
//         Expanded(
//           child: KeyboardVisibilityBuilder(
//             builder: (context, isKeyboardVisible) {
//               if (isKeyboardVisible) {
//                 // Delay to allow keyboard animation
//                 Future.delayed(Duration(milliseconds: 100), () {
//                   chatUIProvider.scrollToBottom();
//                 });
//               }
              
//               return ListView.builder(
//                 controller: chatUIProvider.scrollController,
//                 padding: EdgeInsets.symmetric(vertical: 8),
//                 itemCount: messageProvider.messages.length +
//                     (userStatusProvider.isReceiverTyping ? 1 : 0),
//                 itemBuilder: (context, index) {
//                   // Show typing indicator
//                   if (userStatusProvider.isReceiverTyping &&
//                       index == messageProvider.messages.length) {
//                     return Align(
//                       alignment: Alignment.centerLeft,
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 12),
//                         child: TypeIndicator(),
//                       ),
//                     );
//                   }
                  
//                   final message = messageProvider.messages[index];
//                   final isSentByMe = message.senderId == currentUserId;
                  
//                   return GestureDetector(
//                     onLongPress: () {
//                       chatUIProvider.toggleSelectionMode(true);
//                       chatUIProvider.toggleMessageSelection(message.messageId);
//                     },
//                     onTap: chatUIProvider.isSelectionMode
//                         ? () => chatUIProvider.toggleMessageSelection(message.messageId)
//                         : null,
//                     child: Align(
//                       alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
//                       child: MessageBubble(
//                         message: message, 
//                         isSentByMe: isSentByMe,
//                         isSelected: chatUIProvider.selectedMessageIds.contains(message.messageId),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         ),
        
//         // Show recording UI if currently recording
//         if (messageProvider.isRecording)
//           VoiceRecordingWidget(
//             duration: messageProvider.recordDuration,
//             onCancel: () => coordinator.cancelRecording(),
//             onSend: () => coordinator.stopRecordingAndSend(),
//           ),
          
//         MessageInputField(
//           controller: userStatusProvider.messageController,
//           senderId: currentUserId,
//           receiverId: user.uid,
//           isRecording: messageProvider.isRecording,
//           onStartRecording: () => coordinator.startRecording(),
//           onAttach: () async {
//             final imagePicker = ImagePicker();
//             final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
//             if (pickedImage != null) {
//               coordinator.sendImage(pickedImage.path);
//             }
//           },
//           onSend: () async {
//             String messageText = userStatusProvider.messageController.text.trim();

//             if (messageText.isNotEmpty) {
//               await coordinator.sendMessage(messageText);
//               userStatusProvider.messageController.clear();
//               chatUIProvider.scrollToBottom();
//             }
//           },
//         ),
//       ],
//     );
//   }

//   Image chatScreenBackgroundImage(BuildContext context) {
//     return Image.asset(
//       "assets/images/whatsapp_background.png",
//       height: MediaQuery.of(context).size.height,
//       width: MediaQuery.of(context).size.width,
//       fit: BoxFit.cover,
//     );
//   }
// }

// // You'll need to update your ChatAppBar to accept isSelectionMode and lastSeen
// class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final UserModel user;
//   final bool isSelectionMode;
//   final String lastSeen;
//   final VoidCallback onCancelSelection;

//   const ChatAppBar({
//     Key? key,
//     required this.user,
//     required this.onCancelSelection,
//     this.isSelectionMode = false,
//     this.lastSeen = "",
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       leading: isSelectionMode
//           ? IconButton(
//               icon: Icon(Icons.close),
//               onPressed: onCancelSelection,
//             )
//           : BackButton(),
//       title: Row(
//         children: [
//           CircleAvatar(
//             backgroundImage: user.profilePicture != null && user.profilePicture!.isNotEmpty
//                 ? NetworkImage(user.profilePicture!)
//                 : null,
//             child: user.profilePicture == null || user.profilePicture!.isEmpty
//                 ? Text(user.displayName[0])
//                 : null,
//           ),
//           SizedBox(width: 8),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(user.displayName, style: TextStyle(fontSize: 16)),
//                 Text(
//                   lastSeen,
//                   style: TextStyle(fontSize: 12),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       actions: isSelectionMode
//           ? [
//               IconButton(
//                 icon: Icon(Icons.delete),
//                 onPressed: () {
//                   // Access the coordinator to delete messages
//                   final coordinator = Provider.of<ChatCoordinator>(context, listen: false);
//                   coordinator.deleteMessagesForMe();
//                 },
//               ),
//               IconButton(
//                 icon: Icon(Icons.delete_forever),
//                 onPressed: () {
//                   final coordinator = Provider.of<ChatCoordinator>(context, listen: false);
//                   coordinator.deleteMessagesForEveryone();
//                 },
//               ),
//             ]
//           : [
//               IconButton(icon: Icon(Icons.video_call), onPressed: () {}),
//               IconButton(icon: Icon(Icons.call), onPressed: () {}),
//               IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
//             ],
//     );
//   }

//   @override
//   Size get preferredSize => Size.fromHeight(kToolbarHeight);
// }

// // You'll also need to update your MessageBubble to handle selection
// class MessageBubble extends StatelessWidget {
//   final MessageModel message;
//   final bool isSentByMe;
//   final bool isSelected;

//   const MessageBubble({
//     Key? key,
//     required this.message,
//     required this.isSentByMe,
//     this.isSelected = false,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         color: isSelected
//             ? Colors.blueGrey.withOpacity(0.5)
//             : isSentByMe
//                 ? Colors.teal.shade100
//                 : Colors.white,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: _buildMessageContent(),
//     );
//   }

//   Widget _buildMessageContent() {
//     switch (message.messageType) {
//       case MessageType.text:
//         return Text(message.messageContent);
//       case MessageType.image:
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             message.isUploading
//                 ? CircularProgressIndicator()
//                 : Image.network(
//                     message.mediaUrl!,
//                     width: 200,
//                     fit: BoxFit.cover,
//                     loadingBuilder: (context, child, loadingProgress) {
//                       if (loadingProgress == null) return child;
//                       return Center(child: CircularProgressIndicator());
//                     },
//                   ),
//             SizedBox(height: 4),
//             Text(message.messageContent),
//           ],
//         );
//       case MessageType.audio:
//         return AudioMessageBubble(message: message);
//       default:
//         return Text(message.messageContent);
//     }
//   }
// }

// // Updated MessageInputField with additional features
// class MessageInputField extends StatelessWidget {
//   final TextEditingController controller;
//   final String senderId;
//   final String receiverId;
//   final bool isRecording;
//   final VoidCallback onSend;
//   final VoidCallback onStartRecording;
//   final VoidCallback? onAttach;

//   const MessageInputField({
//     Key? key,
//     required this.controller,
//     required this.senderId,
//     required this.receiverId,
//     required this.onSend,
//     required this.onStartRecording,
//     this.onAttach,
//     this.isRecording = false,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//       color: Colors.white,
//       child: Row(
//         children: [
//           IconButton(
//             icon: Icon(Icons.attach_file),
//             onPressed: onAttach,
//           ),
//           Expanded(
//             child: TextField(
//               controller: controller,
//               decoration: InputDecoration(
//                 hintText: 'Type a message',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(24),
//                   borderSide: BorderSide.none,
//                 ),
//                 filled: true,
//                 fillColor: Colors.grey.shade200,
//               ),
//               textInputAction: TextInputAction.send,
//               onSubmitted: (_) => onSend(),
//             ),
//           ),
//           IconButton(
//             icon: Icon(
//               controller.text.isEmpty ? Icons.mic : Icons.send,
//               color: Colors.teal,
//             ),
//             onPressed: controller.text.isEmpty ? onStartRecording : onSend,
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Add a voice recording widget
// class VoiceRecordingWidget extends StatelessWidget {
//   final int duration;
//   final VoidCallback onCancel;
//   final VoidCallback onSend;

//   const VoiceRecordingWidget({
//     Key? key,
//     required this.duration,
//     required this.onCancel,
//     required this.onSend,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final minutes = (duration / 60).floor();
//     final seconds = duration % 60;
    
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       color: Colors.grey.shade200,
//       child: Row(
//         children: [
//           Icon(Icons.mic, color: Colors.red),
//           SizedBox(width: 8),
//           Text(
//             '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 8),
//               child: LinearProgressIndicator(
//                 value: null, // Indeterminate progress
//                 backgroundColor: Colors.grey.shade300,
//                 valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
//               ),
//             ),
//           ),
//           IconButton(
//             icon: Icon(Icons.close),
//             onPressed: onCancel,
//           ),
//           IconButton(
//             icon: Icon(Icons.send, color: Colors.teal),
//             onPressed: onSend,
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Audio message bubble implementation
// class AudioMessageBubble extends StatefulWidget {
//   final MessageModel message;

//   const AudioMessageBubble({Key? key, required this.message}) : super(key: key);

//   @override
//   State<AudioMessageBubble> createState() => _AudioMessageBubbleState();
// }

// class _AudioMessageBubbleState extends State<AudioMessageBubble> {
//   late AudioPlayer audioPlayer;
//   bool isPlaying = false;
//   Duration duration = Duration.zero;
//   Duration position = Duration.zero;

//   @override
//   void initState() {
//     super.initState();
//     audioPlayer = AudioPlayer();
//     initPlayer();
//   }

//   Future<void> initPlayer() async {
//     try {
//       await audioPlayer.setUrl(widget.message.mediaUrl!);
//       audioPlayer.durationStream.listen((newDuration) {
//         if (mounted) {
//           setState(() {
//             duration = newDuration ?? Duration.zero;
//           });
//         }
//       });

//       audioPlayer.positionStream.listen((newPosition) {
//         if (mounted) {
//           setState(() {
//             position = newPosition;
//           });
//         }
//       });

//       audioPlayer.playerStateStream.listen((state) {
//         if (mounted) {
//           setState(() {
//             isPlaying = state.playing;
//           });
//         }
//       });
//     } catch (e) {
//       print("Error initializing audio player: $e");
//     }
//   }

//   @override
//   void dispose() {
//     audioPlayer.dispose();
//     super.dispose();
//   }

//   String formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//     return "$minutes:$seconds";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         IconButton(
//           icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
//           onPressed: () {
//             if (isPlaying) {
//               audioPlayer.pause();
//             } else {
//               audioPlayer.play();
//             }
//           },
//         ),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Slider(
//                 value: position.inSeconds.toDouble(),
//                 min: 0,
//                 max: duration.inSeconds.toDouble() == 0
//                     ? widget.message.audioDuration.toDouble()
//                     : duration.inSeconds.toDouble(),
//                 onChanged: (value) async {
//                   final position = Duration(seconds: value.toInt());
//                   await audioPlayer.seek(position);
//                 },
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(formatDuration(position)),
//                   Text(formatDuration(duration.inSeconds > 0
//                       ? duration
//                       : Duration(seconds: widget.message.audioDuration))),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }