import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickImage) imagePickFn;
  const UserImagePicker({Key? key, required this.imagePickFn})
      : super(key: key);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  checkCameraPermission() async {
    var cameraPermission = await Permission.camera.status;
    var microphonePermission = await Permission.microphone.status;

    //ask permission
    if (!cameraPermission.isGranted) {
      await Permission.camera.request();
    }

    if (!microphonePermission.isGranted) {
      await Permission.camera.request();
    }
    

    //after get the permission
    if (cameraPermission.isGranted && microphonePermission.isGranted) {
      _pickImage();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Require camera permission to proceed')));
    }
  }

  void _pickImage() async {
    final pickedImageFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxHeight: 150,
      maxWidth: 150,
      imageQuality: 50,
    );

    setState(() {
      _pickedImage = File(pickedImageFile.path);
    });

    widget.imagePickFn(File(pickedImageFile.path));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      CircleAvatar(
        radius: 70,
        backgroundColor: Colors.grey,
        backgroundImage: _pickedImage != null
            ? FileImage(_pickedImage!)
            : const AssetImage('assets/profile-image-placeholder.jpg')
                as ImageProvider,
      ),
      TextButton.icon(
        style: TextButton.styleFrom(primary: Theme.of(context).primaryColor),
        onPressed: _pickImage,
        icon: const Icon(Icons.image),
        label: const Text('Add Image'),
      )
    ]);
  }
}
