import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
              return userTile(
                searchResultSnapshot.documents[index].data["username"],
                searchResultSnapshot.documents[index].data["email"],
                searchResultSnapshot.documents[index].documentID,
                searchResultSnapshot.documents[index].data["image_url"],
              );
            })
        : const SizedBox();
  }

  Widget userTile(
      String userName, String userEmail, String uid, String userImage) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, MessageScreen.routeName, arguments: {
            'receiverUsername': userName,
            'receiverUid': uid,
            'currentUid': widget.currentUser,
            'userImage': userImage
          });
        },
        child: FriendTile(userName: userName, userImage: userImage, recentMessage: userEmail, recentTime: ''));
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
            userList(),
          ],
        ));
  }
}
