import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../helper/current_user_data.dart';
import '../helper/helper_functions.dart';
import '../screens/message_screen.dart';
import '../widgets/home/friend_tile.dart';
import '../services/database_functions.dart';

class SearchUserPage extends StatefulWidget {
  final String currentUser;
  const SearchUserPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  _SearchUserPageState createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  DatabaseFunctions databaseFunctions = DatabaseFunctions();
  TextEditingController searchEditingController = TextEditingController();
  late QuerySnapshot searchResultSnapshot;
  late Stream<QuerySnapshot> allUserStream;
  List<DocumentSnapshot> userInfo = [];
  bool isLoading = false;
  bool haveUserSearched = false;

  @override
  void initState() {
    allUserStream =
        allUserStream = Firestore.instance.collection('users').snapshots();
    super.initState();
  }

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
    return StreamBuilder<QuerySnapshot>(
        stream: allUserStream,
        builder: (ctx, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          userInfo = userSnapshot.data!.documents;
          if (searchEditingController.text.isNotEmpty) {
            userInfo = userInfo.where((element) {
              return element['username']
                  .toString()
                  .toLowerCase()
                  .contains(searchEditingController.text.toLowerCase());
            }).toList();
          }
          return ListView.builder(
              itemCount: userInfo.length,
              itemBuilder: (listViewCtx, index) {
                if (userInfo[index].documentID == CurrentUserData.userId) {
                  return const SizedBox(height: 0, width: 0);
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
                  onChanged: (_) {
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
