import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pigeon_post/helper/gestures.dart';
import '../helper/current_user_data.dart';
import '../screens/message_screen.dart';
import '../widgets/home/friend_tile.dart';
import '../models/date_formatter.dart';

class ChatRoomListPage extends StatefulWidget {
  const ChatRoomListPage({Key? key}) : super(key: key);

  @override
  State<ChatRoomListPage> createState() => _ChatRoomListPageState();
}

class _ChatRoomListPageState extends State<ChatRoomListPage>
    with AutomaticKeepAliveClientMixin<ChatRoomListPage> {
  late Stream<QuerySnapshot> chatRoomStream;

  @override
  void initState() {
    chatRoomStream = Firestore.instance
        .collection('chatRoom')
        .where('users', arrayContains: CurrentUserData.userId)
        .orderBy('recentTime', descending: true)
        .snapshots();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: chatRoomStream,
        builder: (ctx, chatRoomSnapshot) {
          if (chatRoomSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final chatRoomData = chatRoomSnapshot.data!.documents;
          return ListView.separated(
              itemCount: chatRoomData.length,
              separatorBuilder: (sepCtx, index) {
                return const Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Divider(
                    thickness: 1,
                  ),
                );
              },
              itemBuilder: (listviewCTX, index) {
                late String receiverId;
                late String receiverUserName;
                late String receiverUserImage;
                for (int i = 0; i < chatRoomData[index]['users'].length; i++) {
                  if (chatRoomData[index]['users'][i] !=
                      CurrentUserData.userId) {
                    receiverId = chatRoomData[index]['users'][i];
                    receiverUserName =
                        chatRoomData[index]['usersData']['usernames'][i];
                    receiverUserImage =
                        chatRoomData[index]['usersData']['image_url'][i];
                    break;
                  }
                }

                var recentTimeData = chatRoomData[index]['recentTime'] != null
                    ? DateFormatter().getVerboseDateTime(
                        chatRoomData[index]['recentTime'].toDate())
                    : '';

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Gestures().pushToMessageScreen(
                        context,
                        receiverId,
                        receiverUserName,
                        receiverUserImage,
                        chatRoomData[index].documentID);
                  },
                  child: FriendTile(
                    userName: receiverUserName,
                    userImage: receiverUserImage,
                    recentMessage: chatRoomData[index]['recentMessage'] ?? '',
                    recentTime: recentTimeData,
                  ),
                );
              });
        });
  }

  @override
  bool get wantKeepAlive => true;
}
