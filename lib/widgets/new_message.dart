import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  final String receiverUid;
  const NewMessage({Key? key, required this.receiverUid}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  var _messageContent = '';

  void _sendMessage() async {
    FocusScope.of(context).unfocus();

    final user = await FirebaseAuth.instance.currentUser();
    final userData =
        await Firestore.instance.collection('users').document(user.uid).get();

    Firestore.instance.collection('chat').add({
      'text': _messageContent,
      'sentAt': Timestamp.now(),
      'sender': user.uid,
      'username': userData['username'],
      'receiver': widget.receiverUid,
      'timeSent': DateTime.now(),
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
