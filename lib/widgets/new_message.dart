import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pigeon_post/helper/current_user_data.dart';
import 'package:pigeon_post/helper/helper_functions.dart';

class NewMessage extends StatefulWidget {
  final String receiverUid;
  final String receiverUserName;
  final String chatRoomId;
  const NewMessage(
      {Key? key,
      required this.receiverUid,
      required this.receiverUserName,
      required this.chatRoomId})
      : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  var _messageContent = '';
  late String chatRoomId;

  void _sendMessage() async {
    FocusScope.of(context).unfocus();

    final user = await FirebaseAuth.instance.currentUser();
    final userData =
        await Firestore.instance.collection('users').document(user.uid).get();

    _controller.clear();

    //send message to chatroom
    Firestore.instance
        .collection("chatRoom")
        .document(widget.chatRoomId)
        .collection("chats")
        .add({
      'text': _messageContent,
      'sender': user.uid,
      'username': userData['username'],
      'receiver': widget.receiverUid,
      'timeSent': DateTime.now(),
    });

    Firestore.instance.collection("chatRoom").document(widget.chatRoomId).updateData({
      'recentMessage': _messageContent,
      'recentTime': DateTime.now(),
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);
    return Container(
      height: queryData.size.height * 0.08,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.only(left: 13, right: 8, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(35)),
                  color: Color(0xFFB0CBE8)),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                    hintText: 'Send a message...', border: InputBorder.none),
                onChanged: (value) {
                  setState(() {
                    _messageContent = value;
                  });
                },
                onSubmitted: (value) => _sendMessage(),
              ),
            ),
          ),
          IconButton(
              onPressed:
                  _messageContent.trim().isEmpty ? null : () => _sendMessage(),
              icon: const Icon(
                Icons.send,
                color: Color(0xFF83B0D8),
              ))
        ],
      ),
    );
  }
}
