import 'package:flutter/material.dart';
import 'package:pigeon_post/models/date_formatter.dart';

class MessageBubble extends StatelessWidget {
  final String username;
  final String message;
  final DateTime timeSent;
  final String translatedMessage;
  final bool isMe;
  final bool isTranslated;

  const MessageBubble(
      {Key? key,
      required this.username,
      required this.message,
      required this.timeSent,
      required this.translatedMessage,
      required this.isMe,
      required this.isTranslated})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
            color: isTranslated
              ? isMe
                ? Colors.teal[300]
                : Colors.blueGrey[600]
              : isMe
                ? const Color(0xff99a88e) //const Color(0xffb9aefe) //Theme.of(context).primaryColor
                : Colors.black54, // Color(0xFFcbff00),
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(23),
                topRight: const Radius.circular(23),
                bottomLeft:
                    isMe ? const Radius.circular(23) : const Radius.circular(0),
                bottomRight: isMe
                    ? const Radius.circular(0)
                    : const Radius.circular(23))),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 17),
                textAlign: TextAlign.left,
              ),
              translatedMessage != ''
                  ? Text(
                      translatedMessage,
                      style: const TextStyle(
                          color: Colors.white54,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    )
                  : const SizedBox(height: 0),
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  DateFormatter().getVerboseDateTime(timeSent),
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ]),
      ),
    );
  }
}
