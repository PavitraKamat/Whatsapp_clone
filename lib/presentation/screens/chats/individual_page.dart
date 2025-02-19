import 'package:flutter/material.dart';
import 'package:wtsp_clone/data/models/contact_model.dart';

class IndividualPage extends StatefulWidget {
  final ContactModel contact;

  const IndividualPage({super.key, required this.contact});

  @override
  _IndividualPageState createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage> {
  TextEditingController _messageController = TextEditingController();
  List<String> messages = [];
  bool isTyping = false;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() {
      setState(() {
        isTyping = _messageController.text.isNotEmpty;
      });
    });
  }

  void sendMessage() {
    if (_messageController.text.isNotEmpty) {
      String userMessage = _messageController.text;

      setState(() {
        messages.add(userMessage);
        _messageController.clear();
      });
      print("User sent: $userMessage");
      Future.delayed(Duration(microseconds: 300), () {
        String responseMessage = "$userMessage";
        setState(() {
          messages.add(responseMessage);
        });
        print("Received response: $responseMessage");
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Image.asset(
        "assets/images/whatsapp_background.png",
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
      Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          titleSpacing: 0,
          leadingWidth: 80,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back, size: 24, color: Colors.black),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blueGrey,
                  backgroundImage: widget.contact.image.isNotEmpty
                      ? AssetImage(widget.contact.image)
                      : AssetImage("assets/images/profile.jpg"),
                ),
              ],
            ),
          ),
          title: InkWell(
            child: Container(
              margin: EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.contact.name,
                    style:
                        TextStyle(fontSize: 18.5, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "last seen today at 5:59 PM",
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.video_call)),
            IconButton(onPressed: () {}, icon: Icon(Icons.call)),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert),
              onSelected: (value) => print(value),
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(child: Text("Search"), value: "Search"),
                PopupMenuItem(child: Text("Add to List"), value: "Add to List"),
                PopupMenuItem(
                    child: Text("Media, Links, and Docs"), value: "Media"),
              ],
            ),
          ],
          backgroundColor: Colors.teal,
        ),
        body: Stack(
          children: [
            ListView(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsets.only(bottom: 10.0, left: 10, right: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: TextFormField(
                            controller: _messageController,
                            textAlignVertical: TextAlignVertical.center,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: "Type a message",
                              border: InputBorder.none,
                              prefixIcon: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.emoji_emotions),
                                color: const Color.fromARGB(255, 53, 52, 52),
                              ),
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.attach_file)),
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.camera_alt)),
                                ],
                              ),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Padding(
                      padding: const EdgeInsets.only(right: 5, bottom: 2),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.teal,
                        child: IconButton(
                          icon: Icon(
                            isTyping ? Icons.send : Icons.mic,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (isTyping) {
                              sendMessage();
                            } else {
                              print("Recording voice message");
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ]);
  }
}
