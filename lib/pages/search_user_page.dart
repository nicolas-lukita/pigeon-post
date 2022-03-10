import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pigeon_post/widgets/friend_tile.dart';

class SearchUserPage extends StatefulWidget {
  final String currentUser;
  const SearchUserPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  _SearchUserPageState createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  Widget _showAllUser() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('users')
          //.where('username', isEqualTo: _searchController)
          .snapshots(),
      builder: (ctx, userSnapShot) {
        if (userSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final users = userSnapShot.data!.documents;
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (ctx, index) {
            return Container(
              child: users[index].documentID != widget.currentUser &&
                      users[index]['username'] == _searchController
                  ? FriendTile(
                      userName: users[index]['username'],
                      userImage: users[index]['image_url'],
                      recentMessage: '',
                      recentTime: '',
                    )
                  : null,
            );
          },
        );
      },
    );
  }

  Widget _showSearchedUser() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('users')
          .where('username', isEqualTo: _searchController)
          .snapshots(),
      builder: (ctx, userSnapShot) {
        if (userSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final users = userSnapShot.data!.documents;
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (ctx, index) {
            return Container(
              child: users[index].documentID != widget.currentUser
                  ? FriendTile(
                      userName: users[index]['username'],
                      userImage: users[index]['image_url'],
                      recentMessage: '',
                      recentTime: '',
                    )
                  : null,
            );
          },
        );
      },
    );
  }

  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Search users'),
          backgroundColor: Theme.of(context).splashColor,
        ),
        body: Column(
          children: [
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search..',
                    border: InputBorder.none,
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor)),
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 24,
                      color: Colors.grey,
                    ),
                    suffixIcon: (_searchController.text.isNotEmpty)
                        ? IconButton(
                            icon: const Icon(Icons.close),
                            color: Colors.grey,
                            //clear button ('x' button)
                            onPressed: () {
                              setState(() {
                                _searchController.text = ""; // Reset the text
                              });
                            })
                        : null,
                  ),
                  onChanged: (txt) {
                    setState(() {});
                  },
                )),
            Expanded(child: _showAllUser())
          ],
        ));
  }
}
