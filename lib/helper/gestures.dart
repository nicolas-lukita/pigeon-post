import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pigeon_post/helper/current_user_data.dart';
import 'package:pigeon_post/screens/message_screen.dart';
import 'package:pigeon_post/services/database_functions.dart';

import 'helper_functions.dart';

class Gestures {
  createThenNavigateToChatRoom(
      BuildContext context, String receiverId, DocumentSnapshot userDocs) {
    String chatRoomId =
        HelperFunctions.chatRoomIdGenerator(CurrentUserData.userId, receiverId);
    DatabaseFunctions().checkChatRoomExistance(chatRoomId).then((value) =>
        !value
            ? Firestore.instance
                .collection("chatRoom")
                .document(chatRoomId)
                .setData({
                "users": [CurrentUserData.userId, receiverId],
                "chatRoomId": chatRoomId,
                'recentMessage': '',
                'recentTime': null,
                "usersData": {
                  "users": [CurrentUserData.userId, receiverId],
                  "usernames": [CurrentUserData.username, userDocs['username']],
                  "image_url": [
                    CurrentUserData.imageUrl,
                    userDocs['image_url']
                  ],
                  "emails": [CurrentUserData.userEmail, userDocs['email']],
                }
              })
            : null);
    pushToMessageScreen(context, receiverId, userDocs['username'], userDocs['image_url'], chatRoomId);
  }

  pushToMessageScreen(BuildContext context, String receiverId,
      String receiverUsername, String receiverImageUrl, String chatRoomId) {

    Navigator.pushNamed(context, MessageScreen.routeName, arguments: {
      'receiverUsername': receiverUsername,
      'receiverUid': receiverId,
      'currentUid': CurrentUserData.userId,
      'userImage': receiverImageUrl,
      'chatRoomId': chatRoomId,
    });
  }
}
