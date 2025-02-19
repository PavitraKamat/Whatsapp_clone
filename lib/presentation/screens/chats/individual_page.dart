import 'package:flutter/material.dart';
import 'package:wtsp_clone/data/models/contact_model.dart';

class IndividualPage extends StatefulWidget {
  final ContactModel contact;

  const IndividualPage({super.key, required this.contact});
  @override
  _IndividulPageState createState() => _IndividulPageState();
}

class _IndividulPageState extends State<IndividualPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        titleSpacing: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_back,
                size: 24,
                color: Colors.black,
              ),
              CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.blueGrey,
                  backgroundImage: widget.contact.image.isNotEmpty
                      ? AssetImage(widget.contact.image)
                      : AssetImage("assets/images/profile.jpg"))
            ],
          ),
        ),
        title: InkWell(
          child: Container(
            margin: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.contact.name,
                  style: TextStyle(fontSize: 18.5, fontWeight: FontWeight.bold),
                ),
                Text(
                  "last seen today at 5.59pm",
                  style: TextStyle(
                    fontSize: 13,
                  ),
                )
              ],
            ),
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.video_call)),
          IconButton(onPressed: () {}, icon: Icon(Icons.call)),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: (value) {
              print(value);
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(child: Text("Search"), value: "Search"),
                PopupMenuItem(child: Text("Add to List"), value: "Add to List"),
                PopupMenuItem(
                    child: Text("Media,links and docs"),
                    value: "Media,links and docs"),
              ];
            },
          )
        ],
        backgroundColor: Colors.teal,
      ),
    );
  }
}
