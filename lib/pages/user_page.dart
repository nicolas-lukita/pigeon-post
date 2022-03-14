import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pigeon_post/helper/current_user_data.dart';
import 'package:pigeon_post/helper/helper_functions.dart';
import 'package:pigeon_post/screens/message_screen.dart';
import 'package:pigeon_post/services/database_functions.dart';
import 'package:pigeon_post/widgets/home/friend_tile.dart';
import 'package:pigeon_post/widgets/home/user_button.dart';
import '../models/date_formatter.dart';
import '../helper/gestures.dart';

class userPage extends StatefulWidget {
  const userPage({Key? key}) : super(key: key);

  @override
  _userPageState createState() => _userPageState();
}

class _userPageState extends State<userPage>
    with AutomaticKeepAliveClientMixin<userPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  late Stream<QuerySnapshot> userStream;

  @override
  void initState() {
    userStream = Firestore.instance
        .collection('users')
        .orderBy('username', descending: false)
        .snapshots();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: userStream,
        builder: (ctx, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final userInfo = userSnapshot.data!.documents;
          return ListView.builder(
              itemCount: userInfo.length,
              itemBuilder: (listviewCTX, index) {
                var receiverId = userInfo[index].documentID;
                //generate chatroomid
                String chatRoomId = HelperFunctions.chatRoomIdGenerator(
                    CurrentUserData.userId, receiverId);

                if (userInfo[index].documentID != CurrentUserData.userId) {
                  // FIX THIS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                  return Column(children: [
                    Row(children: <Widget>[
                      Expanded(
                        child: FriendTile(
                          userName: userInfo[index]['username'],
                          userImage: userInfo[index]['image_url'],
                          recentMessage: userInfo[index]
                              ['email'], //snapshotData['recentMessage'],
                          recentTime: '',
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => Gestures().createThenNavigateToChatRoom(
                              context, receiverId, userInfo[index])
                        ,
                        child: const UserButton(),
                      )
                    ]),
                    const Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Divider(
                        thickness: 1,
                      ),
                    )
                  ]); //snapshotData['recentTime']);

                  // child: StreamBuilder<QuerySnapshot>(
                  //     stream: Firestore.instance
                  //         .collection('chatRoom')
                  //         .where('chatRoomId', isEqualTo: chatRoomId)
                  //         .snapshots(),
                  //     builder: (ctx, chatRoomSnapshot) {
                  //       if (chatRoomSnapshot.connectionState ==
                  //           ConnectionState.waiting) {
                  //         return const Center(
                  //             child: CircularProgressIndicator());
                  //       }

                  //       var recentMessageData;
                  //       var recentTimeData;

                  //       if (chatRoomSnapshot.data!.documents[0] != null) {
                  //         recentMessageData = chatRoomSnapshot
                  //             .data!.documents[0]['recentMessage'];
                  //         recentTimeData = DateFormatter().getVerboseDateTime(
                  //             chatRoomSnapshot
                  //                 .data!.documents[0]['recentTime']
                  //                 .toDate());
                  //       } else {
                  //         recentMessageData = '';
                  //         recentTimeData = '';
                  //       }

                  //       return userInfo[index].documentID !=
                  //               CurrentUserData.userId
                  //           ? FriendTile(
                  //               userName: userInfo[index]['username'],
                  //               userImage: userInfo[index]['image_url'],
                  //               recentMessage: recentMessageData ?? '',
                  //               recentTime: recentTimeData ?? '',
                  //             )
                  //           : const SizedBox(height: 0, width: 0);
                  //     })

                } else {
                  return SizedBox();
                }
              });
        });
  }

  @override
  bool get wantKeepAlive => true;
}
