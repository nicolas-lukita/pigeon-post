import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pigeon_post/screens/message_screen.dart';
import 'package:pigeon_post/widgets/friend_tile.dart';

class userPage extends StatefulWidget {
  final String currentUser;
  const userPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  _userPageState createState() => _userPageState();
}

class _userPageState extends State<userPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('users').snapshots(),
              builder: (ctx, userSnapShot) {
                if (userSnapShot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final userInfo = userSnapShot.data!.documents;
                return ListView.builder(
                    itemCount: userInfo.length,
                    itemBuilder: (listviewCTX, index) {
                      var receiverId = userInfo[index].documentID;
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.pushNamed(context, MessageScreen.routeName,
                              arguments: {
                                'receiverUsername': userInfo[index]['username'],
                                'receiverUid': receiverId,
                                'currentUid': widget.currentUser
                              });
                        },
                        child: StreamBuilder<QuerySnapshot>(
                            stream: Firestore.instance
                                .collection('chat')
                                .orderBy('timeSent', descending: true)
                                .snapshots(),
                            builder: (ctx, chatSnapShot) {
                              if (chatSnapShot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              String recentMessage = '';
                              final chatDocs = chatSnapShot.data!.documents;
                              //get the most recent message
                              for (int i = 0; i < chatDocs.length; i++) {
                                if ((chatDocs[i]['receiver'] == receiverId &&
                                        chatDocs[i]['sender'] ==
                                            widget.currentUser) ||
                                    (chatDocs[i]['receiver'] ==
                                            widget.currentUser &&
                                        chatDocs[i]['sender'] == receiverId)) {
                                  recentMessage = chatDocs[i]['text'];
                                  break;
                                }
                              }
                              return Container(
                                child: userInfo[index].documentID !=
                                        widget.currentUser
                                    ? FriendTile(
                                        userName: userInfo[index]['username'],
                                        userImage: userInfo[index]['image_url'],
                                        recentMessage: recentMessage,
                                      )
                                    : null,
                              );
                            }),
                      );
                    });
              }),
        )
      ],
    );
  }
}
