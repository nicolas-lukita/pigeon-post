import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pigeon_post/helper/current_user_data.dart';
import 'package:pigeon_post/providers/language_provider.dart';
import 'package:pigeon_post/widgets/message_bubble.dart';
import 'package:provider/src/provider.dart';
import './message_translator.dart';

class Message extends StatefulWidget {
  final String currentUid;
  final String receiverUid;
  final String chatRoomId;
  final bool isTranslate;
  const Message(
      {Key? key,
      required this.currentUid,
      required this.receiverUid,
      required this.isTranslate,
      required this.chatRoomId})
      : super(key: key);

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  String userUId = '';
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        userUId = user.uid;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("chatRoom")
            .document(widget.chatRoomId)
            .collection("chats")
            .orderBy("timeSent", descending: true)
            .snapshots(),
        builder: (ctx, chatSnapShot) {
          if (chatSnapShot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final chatData = chatSnapShot.data!.documents;
          return chatSnapShot.hasData
              ? ListView.builder(
                  itemCount: chatData.length,
                  reverse: true,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    if (widget.isTranslate) {
                      return MessageTranslator(
                        text: chatData[index]['text'],
                        language1Code:
                            context.watch<LanguageProvider>().language1.code,
                        language2Code:
                            context.watch<LanguageProvider>().language2.code,
                        builder: (translatedMessage) => MessageBubble(
                          username: chatData[index]['username'],
                          message: chatData[index]['text'],
                          timeSent: chatData[index]['timeSent'].toDate(),
                          translatedMessage: translatedMessage,
                          isMe: chatData[index]['sender'] ==
                              CurrentUserData.userId,
                        ),
                      );
                    } else {
                      return MessageBubble(
                        username: chatData[index]['username'],
                        message: chatData[index]['text'],
                        timeSent: chatData[index]['timeSent'].toDate(),
                        translatedMessage: '',
                        isMe:
                            chatData[index]['sender'] == CurrentUserData.userId,
                      );
                    }
                  })
              : const SizedBox();
        });
  }
}
