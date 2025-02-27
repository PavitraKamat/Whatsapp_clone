import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wtsp_clone/presentation/widgets/bottom_sheet.dart';
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
    _nameController = TextEditingController(text: widget.name);
    _statusController = TextEditingController(text: widget.status);
    _image = widget.image; // Use the passed image
    _loadImage(); // Load saved image from storage
  }

  void _loadImage() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/profile_image.png';
    File file = File(filePath);

    if (file.existsSync()) {
      Uint8List imgBytes = await file.readAsBytes();
      setState(() {
        _image = imgBytes;
      });
      print("Loaded saved image.");
    } else {
      print("No saved image found.");
    }
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);

    // Get app's document directory
    if (img != null) {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/profile_image.png';
      File file = File(filePath);

      // Save the selected image to storage
      await file.writeAsBytes(img);

      // Debugging output
      print("Image saved at: $filePath");
      print("Image file exists: ${file.existsSync()}");

      setState(() {
        _image = img;
      });

      widget.onImageSelected(img);
    }
  }

  void _showEditBottomSheet({
    required String title,
    required TextEditingController controller,
    required Function(String) onSave,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => EditBottomSheet(
        title: title,
        controller: controller,
        onSave: onSave,
      ),
    );
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
          ListTile(
            leading: Icon(Icons.person, color: Colors.teal),
            title: Text("Name", style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(widget.name),
            onTap: () => _showEditBottomSheet(
              title: "Name",
              controller: _nameController,
              onSave: widget.onNameChanged,
            ),
          ),
          //Divider(),
          ListTile(
            leading: Icon(Icons.info, color: Colors.teal),
            title: Text("About", style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(widget.status),
            //
            onTap: () => _showEditBottomSheet(
              title: "About",
              controller: _statusController,
              onSave: widget.onStatusChanged,
            ),
          ),
          //Divider(),
          ListTile(
            leading: Icon(Icons.phone, color: Colors.teal),
            title: Text("Phone Number",
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(widget.phoneNumber),
          ),
        ],
      ),
    );
  }
}
