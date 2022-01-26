import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  //final Key key;
  final String username;
  final String message;
  final bool isMe;

  MessageBubble(
      {
      //required this.key,
      required this.username,
      required this.message,
      required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: isMe
                  ? const Color(
                      0xff99a88e) //const Color(0xffb9aefe) //Theme.of(context).primaryColor
                  : Colors.black54, // Color(0xFFcbff00),
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(23),
                  topRight: const Radius.circular(23),
                  bottomLeft: isMe
                      ? const Radius.circular(23)
                      : const Radius.circular(0),
                  bottomRight: isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(23))),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(children: <Widget>[
            Text(
              username,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
            const Text(
              '[translated message]',
              style:
                  TextStyle(color: Colors.white54, fontStyle: FontStyle.italic),
            )
          ]),
        )
      ],
    );
  }
}
