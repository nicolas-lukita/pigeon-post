import 'package:flutter/material.dart';

class UserButton extends StatelessWidget {
  const UserButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    //MAKE IT PRETTIER LATER!!!
    return Container(
        margin: const EdgeInsets.only(top: 10, right: 35, left: 15),
        child: const Icon(Icons.send));
  }
}
