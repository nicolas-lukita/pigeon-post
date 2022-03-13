import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pigeon_post/helper/current_user_data.dart';
import 'package:pigeon_post/helper/helper_functions.dart';
import 'package:pigeon_post/screens/message_screen.dart';
import 'package:pigeon_post/widgets/friend_tile.dart';
import '../services/database_functions.dart';

class SearchUserPage extends StatefulWidget {
  final String currentUser;
  const SearchUserPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  _SearchUserPageState createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  DatabaseFunctions databaseFunctions = new DatabaseFunctions();
  TextEditingController searchEditingController = new TextEditingController();
  late QuerySnapshot searchResultSnapshot;
  bool isLoading = false;
  bool haveUserSearched = false;

  initiateSearch() async {
    if (searchEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await databaseFunctions
          .searchByUsername(searchEditingController.text)
          .then((snapshot) {
        searchResultSnapshot = snapshot;
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  Widget userList() {
    return haveUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchResultSnapshot.documents.length,
            itemBuilder: (context, index) {
              if (searchResultSnapshot.documents[index].documentID !=
                  CurrentUserData.userId) {
                return userTile(
                  searchResultSnapshot.documents[index].data["username"],
                  searchResultSnapshot.documents[index].data["email"],
                  searchResultSnapshot.documents[index].documentID,
                  searchResultSnapshot.documents[index].data["image_url"],
                );
              } else {
                return const SizedBox();
              }
            })
        : StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('users').snapshots(),
            builder: (ctx, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final userInfo = userSnapshot.data!.documents;
              return ListView.builder(
                  itemCount: userInfo.length,
                  itemBuilder: (listViewCtx, index) {
                    if (userInfo[index].documentID == CurrentUserData.userId) {
                      return const SizedBox(height:0, width:0);
                    }
                    return userTile(
                      userInfo[index]['username'],
                      userInfo[index]['email'],
                      userInfo[index].documentID,
                      userInfo[index]["image_url"],
                    );
                  });
            });
  }

  Widget userTile(
      String userName, String userEmail, String uid, String userImage) {
    return GestureDetector(
        onTap: () {
          //generate chatroomid
          String chatRoomId =
              HelperFunctions.chatRoomIdGenerator(CurrentUserData.userId, uid);

          DatabaseFunctions().checkChatRoomExistance(chatRoomId).then((value) =>
              !value
                  ? Firestore.instance
                      .collection("chatRoom")
                      .document(chatRoomId)
                      .setData({
                      "users": [CurrentUserData.userId, uid],
                      "chatRoomId": chatRoomId,
                      "Usernames": [CurrentUserData.username, userName],
                      'recentMessage': '',
                      'recentTime': null,
                    })
                  : null);

          Navigator.pushNamed(context, MessageScreen.routeName, arguments: {
            'receiverUsername': userName,
            'receiverUid': uid,
            'currentUid': CurrentUserData.userId,
            'userImage': userImage,
            'chatRoomId': chatRoomId,
          });
        },
        child: FriendTile(
            userName: userName,
            userImage: userImage,
            recentMessage: userEmail,
            recentTime: ''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Search User',
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
          ),
          backgroundColor: Theme.of(context).splashColor,
        ),
        body: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: const Color(0x54FFFFFF),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  onSubmitted: (_) {
                    initiateSearch();
                  },
                  controller: searchEditingController,
                  decoration: InputDecoration(
                    hintText: 'Search..',
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                        gapPadding: 10,
                        borderRadius: BorderRadius.circular(50),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                        )),
                    enabledBorder: OutlineInputBorder(
                      gapPadding: 10,
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        gapPadding: 10,
                        borderRadius: BorderRadius.circular(50),
                        borderSide: const BorderSide(
                          color: Colors.red,
                        )),
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 24,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(child: userList()),
          ],
        ));
  }
}
