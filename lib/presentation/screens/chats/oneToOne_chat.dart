import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wtsp_clone/controller/chat_controller.dart';
import 'package:wtsp_clone/controller/onetooneChat_provider.dart';
import 'package:wtsp_clone/data/models/contact_model.dart';
import 'package:wtsp_clone/presentation/components/message_bubble.dart';
import 'package:wtsp_clone/presentation/components/input_field.dart';
import 'package:wtsp_clone/presentation/components/chat_app_bar.dart';
import 'package:wtsp_clone/presentation/components/type_indicator.dart';

class OnetooneChat extends StatelessWidget {
  final ContactModel contact;

  const OnetooneChat({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnetoonechatProvider(
          contactId: contact.id, chatController: ChatController()),
      lazy: false,
      child: _OnetooneChatScreen(contact: contact),
    );
  }
}

class _OnetooneChatScreen extends StatelessWidget {
  final ContactModel contact;

  const _OnetooneChatScreen({required this.contact});

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<OnetoonechatProvider>(context);

    return Stack(
      children: [
        chatScreenBackgroundImage(context),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: ChatAppBar(contact: contact),
          body: messageTiles(chatProvider),
        ),
      ],
    );
  }

  Column messageTiles(OnetoonechatProvider chatProvider) {
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
            //reverse: true,
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
            chatProvider.sendMessage(chatProvider.messageController.text);
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

