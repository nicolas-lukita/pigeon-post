import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pigeon_post/helper/current_user_data.dart';
import 'package:pigeon_post/helper/helper_functions.dart';
import 'package:pigeon_post/screens/message_screen.dart';
import 'package:pigeon_post/services/database_functions.dart';
import 'package:pigeon_post/widgets/friend_tile.dart';
import '../models/date_formatter.dart';

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

    return StreamBuilder<QuerySnapshot>(
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
                //generate chatroomid
                String chatRoomId = HelperFunctions.chatRoomIdGenerator(
                    CurrentUserData.userId, receiverId);
                return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      DatabaseFunctions()
                          .checkChatRoomExistance(chatRoomId)
                          .then((value) => !value
                              ? Firestore.instance
                                  .collection("chatRoom")
                                  .document(chatRoomId)
                                  .setData({
                                  "users": [CurrentUserData.userId, receiverId],
                                  "chatRoomId": chatRoomId,
                                  "Usernames": [
                                    CurrentUserData.username,
                                    userInfo[index]['username']
                                  ],
                                  'recentMessage': '',
                                  'recentTime': null,
                                })
                              : null);

                      Navigator.pushNamed(context, MessageScreen.routeName,
                          arguments: {
                            'receiverUsername': userInfo[index]['username'],
                            'receiverUid': receiverId,
                            'currentUid': CurrentUserData.userId,
                            'userImage': userInfo[index]['image_url'],
                            'chatRoomId': chatRoomId,
                          });
                    },
                    child: StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection('chatRoom')
                            .where('chatRoomId', isEqualTo: chatRoomId)
                            .snapshots(),
                        builder: (ctx, chatRoomSnapshot) {
                          if (chatRoomSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          return userInfo[index].documentID !=
                                  CurrentUserData.userId
                              ? FriendTile(
                                userName: userInfo[index]['username'],
                                userImage: userInfo[index]['image_url'],
                                recentMessage: chatRoomSnapshot.data!.documents[0]['recentMessage'],
                                recentTime: DateFormatter().getVerboseDateTime(chatRoomSnapshot.data!.documents[0]['recentTime'].toDate()),
                              )
                              : const SizedBox(height: 0, width: 0);
                        })
                    );
              });
        });
  }
}
