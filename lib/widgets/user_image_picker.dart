import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickImage) imagePickFn;
  const UserImagePicker({Key? key, required this.imagePickFn})
      : super(key: key);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

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
        backgroundImage: _pickedImage != null ? FileImage(_pickedImage!) : null,
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
