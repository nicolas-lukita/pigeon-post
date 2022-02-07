import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pigeon_post/api/translator_api.dart';
import 'package:pigeon_post/providers/language_provider.dart';
import 'package:pigeon_post/widgets/message_bubble.dart';
import 'package:provider/src/provider.dart';
import 'package:translator/translator.dart';
import './message_translator.dart';

class Message extends StatefulWidget {
  final String currentUid;
  final String receiverUid;
  const Message({Key? key, required this.currentUid, required this.receiverUid})
      : super(key: key);

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  Future<bool> _checkCurrentUser(String userId) async {
    final user = await FirebaseAuth.instance.currentUser();
    final userUId = user.uid;
    return userId == userUId;
  }

  String userUId = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        userUId = user.uid;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (ctx, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            const Center(
              child: CircularProgressIndicator(),
            );
          }

          return StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('chat')
                .orderBy('sentAt', descending: true)
                .snapshots(),
            builder: (ctx, chatSnapShot) {
              if (chatSnapShot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final chatDocs = chatSnapShot.data!.documents;
              return ListView.builder(
                  reverse: true,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: chatDocs.length,
                  itemBuilder: (ctx, index) {
                    if ((chatDocs[index]['receiver'] == widget.currentUid ||
                            chatDocs[index]['sender'] == widget.currentUid) &&
                        (chatDocs[index]['sender'] == widget.receiverUid ||
                            chatDocs[index]['receiver'] ==
                                widget.receiverUid)) {
                      return MessageTranslator(
                          text: chatDocs[index]['text'],
                          language1Code:
                              context.watch<LanguageProvider>().language1.code,
                          language2Code:
                              context.watch<LanguageProvider>().language2.code,
                          builder: (translatedMessage) => MessageBubble(
                                username: chatDocs[index]['username'],
                                message: chatDocs[index]['text'],
                                translatedMessage: translatedMessage,
                                isMe: chatDocs[index]['sender'] == userUId,
                              ));
                    } else {
                      return const SizedBox(
                        height: 0,
                      );
                    }
                  });
            },
          );
        });
  }
}
