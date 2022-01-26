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
                final userInfo = userSnapShot.data!.documents;
                return ListView.builder(
                    itemCount: userInfo.length,
                    itemBuilder: (listviewCTX, index) {
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          var receiverId = userInfo[index].documentID;
                          print('$receiverId tapped');
                          Navigator.pushNamed(context, MessageScreen.routeName,
                              arguments: {
                                'receiverUsername': userInfo[index]['username'],
                                'receiverUid': receiverId,
                                'currentUid': widget.currentUser
                              });
                        },
                        child: Container(
                          child:
                              userInfo[index].documentID != widget.currentUser
                                  ? FriendTile(
                                      userName: userInfo[index]['username'],
                                      userImage: userInfo[index]['image_url'],
                                    )
                                  : null,
                        ),
                      );
                    });
              }),
        )
      ],
    );
  }
}
