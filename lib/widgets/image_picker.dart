import 'package:flutter/material.dart';
import 'dart:io';

class ImagePicker extends StatefulWidget {
  const ImagePicker({Key? key}) : super(key: key);

  @override
  _ImagePickerState createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 70,
          backgroundColor: Colors.grey,
          //backgroundImage: ,
        ),
        FlatButton.icon(
          textColor: Theme.of(context).primaryColor,
          onPressed: () {},
          icon: Icon(Icons.image),
          label: Text('Add Image'),
        )
      ],
    );
  }
}
