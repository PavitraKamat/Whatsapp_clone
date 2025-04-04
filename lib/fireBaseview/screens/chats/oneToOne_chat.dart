import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/fireBaseController/onetoone_chat_provider.dart';
import 'package:wtsp_clone/fireBasemodel/models/user_model.dart';
import 'package:wtsp_clone/fireBaseview/components/chat_app_bar.dart';
import 'package:wtsp_clone/fireBaseview/components/input_field.dart';
import 'package:wtsp_clone/fireBaseview/components/message_bubble.dart';
import 'package:wtsp_clone/fireBaseview/components/type_indicator.dart';

class FireBaseOnetooneChat extends StatelessWidget {
  final UserModel user;

  const FireBaseOnetooneChat({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        var provider = FireBaseOnetoonechatProvider(user: user);
        provider.openChat(FirebaseAuth.instance.currentUser!.uid, user.uid);
        WidgetsBinding.instance
            .addPostFrameCallback((_) => provider.scrollToBottom());
        return provider;
      },
      //lazy: false,
      //child: _FireBaseOnetooneChatScreen(user: user),
      child: Builder(builder: (context) {
        return _FireBaseOnetooneChatScreen(user: user);
      }),
    );
    // final chatProvider = Provider.of<FireBaseOnetoonechatProvider>(context, listen: false);
    // chatProvider.openChat(FirebaseAuth.instance.currentUser!.uid, user.uid);
    // return _FireBaseOnetooneChatScreen(user: user);
  }
}

class _FireBaseOnetooneChatScreen extends StatelessWidget {
  final UserModel user;
  //final ScrollController _scrollController = ScrollController();
  _FireBaseOnetooneChatScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<FireBaseOnetoonechatProvider>(context);
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //     if (_scrollController.hasClients) {
    //       _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    //     }
    //   });

    return Stack(
      children: [
        chatScreenBackgroundImage(context),
        Scaffold(
            backgroundColor: Colors.transparent,
            appBar: ChatAppBar(user: user),
            body: messageTiles(chatProvider, currentUserId)),
      ],
    );
  }

  Column messageTiles(
      FireBaseOnetoonechatProvider chatProvider, String currentUserId) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
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
                child: MessageBubble(
                    message: message, isSentByMe: isSentByMe), // Fix parameter
              );
            },
          ),
        ),
        MessageInputField(
          controller: chatProvider.messageController,
          //isTyping: chatProvider.isTyping,
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
              // Future.microtask( () {
              //   if (_scrollController.hasClients) {
              //    _scrollController.animateTo(
              //       _scrollController.position.maxScrollExtent,
              //       duration: Duration(milliseconds: 300),
              //       curve: Curves.easeOut,
              //     );
              //   }
              // });
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
