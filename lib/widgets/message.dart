import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pigeon_post/widgets/message_bubble.dart';

class Message extends StatefulWidget {
  const Message({Key? key}) : super(key: key);

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  Future<bool> _checkCurrentUser(String userId) async {
    final user = await FirebaseAuth.instance.currentUser();
    final userUId = user.uid;
    print(userId == userUId);
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
              final chatDocs = chatSnapShot.data!.documents;
              return ListView.builder(
                reverse: true,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: chatDocs.length,
                itemBuilder: (ctx, index) => MessageBubble(
                  username: chatDocs[index]['username'],
                  message: chatDocs[index]['text'],
                  isMe: chatDocs[index]['userId'] == userUId,
                ),
              );
            },
          );
        });
  }
}
