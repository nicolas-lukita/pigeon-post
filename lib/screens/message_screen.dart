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
    // arguments contains: receiverUsername, receiverUid, currentUid, userImage

    return Scaffold(
      appBar: AppBar(
        //leading: BackButton(),
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
            0xff47648a), //Theme.of(context).primaryColor, // Color(0xff72abba),
        actions: [
          // DropdownButton(
          //   dropdownColor: const Color(0xcc4C5B6B),
          //   underline: const SizedBox(), //remove underline below button
          //   icon: const Icon(Icons.more_vert, color: Colors.white),
          //   items: [
          //     DropdownMenuItem(
          //       child: Row(
          //         children: const <Widget>[
          //           Text(
          //             'Logout',
          //             style: TextStyle(color: Color(0xffF7F7FF)),
          //           ),
          //         ],
          //       ),
          //       value: 'logout',
          //     ),
          //     DropdownMenuItem(
          //       child: Row(
          //         children: const <Widget>[
          //           Text(
          //             'translate?',
          //             style: TextStyle(color: Color(0xffF7F7FF)),
          //           ),
          //         ],
          //       ),
          //       value: 'translateToggle',
          //     ),
          //   ],
          //   onChanged: (itemIdentifier) {
          //     if (itemIdentifier == 'logout') {
          //       FirebaseAuth.instance.signOut();
          //     }
          //     switch (itemIdentifier) {
          //       case 'logout':
          //         {
          //           FirebaseAuth.instance.signOut();
          //         }
          //         break;
          //       case 'translateToggle':
          //         {
          //           debugPrint("TRANSLATE TOGGLE PRESSED");
          //           translateToggleHandler();
          //           debugPrint('$isTranslate');
          //         }
          //         break;
          //     }
          //   },
          // )

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
              0xfff4e2d0), //Theme.of(context).splashColor, // Color(0xfffaf8f5), //Theme.of(context).backgroundColor,
          child: Column(
            children: <Widget>[
              const TranslateBar(),
              Expanded(
                  child: Message(
                currentUid: _arguments['currentUid'],
                receiverUid: _arguments['receiverUid'],
                isTranslate: isTranslate,
              )),
              NewMessage(
                receiverUid: _arguments['receiverUid'],
              )
            ],
          )),
    );
  }
}
