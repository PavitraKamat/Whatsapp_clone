import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wtsp_clone/presentation/screens/settings/edit_name_screen.dart';
import 'package:wtsp_clone/presentation/widgets/profile_avatar.dart';
import 'package:wtsp_clone/presentation/widgets/utils.dart';

class ProfileEditScreen extends StatefulWidget {
  final Uint8List? image;
  final String name;
  final String status;
  final String phoneNumber;
  final Function(Uint8List?) onImageSelected;
  final Function(String) onNameChanged;
  final Function(String) onStatusChanged;

  ProfileEditScreen({
    required this.image,
    required this.name,
    required this.status,
    required this.phoneNumber,
    required this.onImageSelected,
    required this.onNameChanged,
    required this.onStatusChanged,
  });

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late TextEditingController _nameController;
  late TextEditingController _statusController;
  Uint8List? _image;

  @override
  void initState() {
    super.initState();
    _image = widget.image;
    _nameController = TextEditingController(text: widget.name);
    _statusController = TextEditingController(text: widget.status);
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
    widget.onImageSelected(img);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text("Edit Profile"), backgroundColor: Colors.white),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Center(
            child: ProfileAvatar(image: _image, radius: 60, onTap: selectImage),
          ),
          SizedBox(height: 30),
          _buildEditableField(
              "Name", _nameController, Icons.person, widget.onNameChanged),
          _buildEditableField(
              "Status", _statusController, Icons.info, widget.onStatusChanged),
          ListTile(
            leading: Icon(Icons.phone, color: Colors.teal),
            title: Text(widget.phoneNumber),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller,
      IconData icon, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.teal),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.teal),
            ),
            filled: true,
            fillColor: Colors.grey[200], // Light grey background
            suffixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.teal),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditNameScreen(
                            name: _nameController.text,
                            status: _statusController.text,
                          ),
                        ),
                      );

                      // If the user saves changes, update the profile screen
                      if (result != null && result is Map<String, String>) {
                        setState(() {
                          _nameController.text = result['name']!;
                          _statusController.text = result['status']!;
                        });

                        widget.onNameChanged(result['name']!);
                        widget.onStatusChanged(result['status']!);
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: Colors.black),
                    onPressed: () {
                      setState(() {
                        controller.clear();
                      });
                      onChanged("");
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
