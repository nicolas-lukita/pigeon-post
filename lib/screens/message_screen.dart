import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/new_message.dart';
import '../widgets/message.dart';
import '../widgets/translate_bar.dart';

class MessageScreen extends StatefulWidget {
  MessageScreen({Key? key}) : super(key: key);
  static const routeName = '/message-screen';

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  bool isTranslate = false;

  void translateToggleHandler() {
    isTranslate = !isTranslate;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final _arguments = ModalRoute.of(context)!.settings.arguments as Map;
    // arguments contains: receiverUsername, receiverUid, currentUid, userImage, chatRoomId

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(_arguments['userImage']),
            ),
            const SizedBox(width: 15),
            Text(_arguments['receiverUsername']),
          ],
        ),
        backgroundColor: const Color(
            0xff47648a), 
        actions: [
          Center(
              child: Switch(
                  value: isTranslate,
                  onChanged: (value) {
                    setState(() {
                      isTranslate = value;
                    });
                  },
                  activeTrackColor: Colors.cyan.shade100,
                  activeColor: Colors.cyan,))
        ],
      ),
      body: Container(
          color: const Color(
              0xfff4e2d0), 
          child: Column(
            children: <Widget>[
              const TranslateBar(),
              Expanded(
                child: Message(
                  currentUid: _arguments['currentUid'],
                  receiverUid: _arguments['receiverUid'],
                  chatRoomId: _arguments['chatRoomId'],
                  isTranslate: isTranslate,
                )
              ),
              NewMessage(
                receiverUid: _arguments['receiverUid'],
                receiverUserName: _arguments['receiverUsername'],
                chatRoomId: _arguments['chatRoomId'],
              )
            ],
          )),
    );
  }
}
