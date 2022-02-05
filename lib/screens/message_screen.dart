import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './login_screen.dart';
import '../widgets/new_message.dart';
import '../widgets/message.dart';
import '../widgets/translate_bar.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({Key? key}) : super(key: key);
  static const routeName = '/message-screen';

  @override
  Widget build(BuildContext context) {
    final _arguments = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        title: _arguments == null
            ? const Text('Pigeon\'s Chat Room')
            : Text(_arguments['receiverUsername']),
        backgroundColor: const Color(
            0xff47648a), //Theme.of(context).primaryColor, // Color(0xff72abba),
        actions: [
          DropdownButton(
            dropdownColor: const Color(0xcc4C5B6B),
            underline: const SizedBox(), //remove underline below button
            icon: const Icon(Icons.more_vert, color: Colors.white),
            items: [
              const DropdownMenuItem(
                child: Text(
                  'Exit',
                  style: TextStyle(color: Color(0xffF7F7FF)),
                ),
                value: 'exit',
              ),
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: const <Widget>[
                      Text(
                        'Logout',
                        style: TextStyle(color: Color(0xffF7F7FF)),
                      )
                    ],
                  ),
                ),
                value: 'logout',
              )
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),
      body: Container(
          color: const Color(
              0xfff4e2d0), //Theme.of(context).splashColor, // Color(0xfffaf8f5), //Theme.of(context).backgroundColor,
          child: Column(
            children: <Widget>[
              TranslateBar(),
              Expanded(
                  child: Message(
                currentUid: _arguments['currentUid'],
                receiverUid: _arguments['receiverUid'],
              )),
              NewMessage(
                receiverUid: _arguments['receiverUid'],
              )
            ],
          )),
    );
  }
}
