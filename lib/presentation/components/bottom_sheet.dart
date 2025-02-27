import 'package:flutter/material.dart';

class EditBottomSheet extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final Function(String) onSave;

  const EditBottomSheet(
      {Key? key,
      required this.title,
      required this.controller,
      required this.onSave})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              hintText: "Enter your $title",
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text("Cancel",
                    style: TextStyle(fontSize: 16, color: Colors.red)),
              ),
              GestureDetector(
                onTap: () {
                  onSave(controller.text);
                  Navigator.pop(context);
                },
                child: Text("Save",
                    style: TextStyle(fontSize: 16, color: Colors.blue)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
