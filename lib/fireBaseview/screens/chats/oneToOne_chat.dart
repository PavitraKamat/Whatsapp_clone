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

  const FireBaseOnetooneChat({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        var provider = FireBaseOnetoonechatProvider(user: user);
        provider.openChat(FirebaseAuth.instance.currentUser!.uid, user.uid);
        return provider;
      },
      lazy: false,
      child: _FireBaseOnetooneChatScreen(user: user),
    );
  }
}

class _FireBaseOnetooneChatScreen extends StatelessWidget {
  final UserModel user;

  const _FireBaseOnetooneChatScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<FireBaseOnetoonechatProvider>(context);

    return Stack(
      children: [
        chatScreenBackgroundImage(context),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: ChatAppBar(user: user),
          body: messageTiles(chatProvider),
        ),
      ],
    );
  }

  Column messageTiles(FireBaseOnetoonechatProvider chatProvider) {
    ScrollController _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
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
              return MessageBubble(message: chatProvider.messages[index]);
            },
          ),
        ),
        MessageInputField(
  controller: chatProvider.messageController,
  onSend: () {
    String user1 = FirebaseAuth.instance.currentUser!.uid;  // Current User
    String user2 = user.uid; // The other user in the chat

    chatProvider.sendMessage(user1, user2, chatProvider.messageController.text);
    
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  },
  isTyping: chatProvider.isTyping,
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
