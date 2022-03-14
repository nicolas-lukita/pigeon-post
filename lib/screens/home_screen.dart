import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../helper/helper_functions.dart';
import '../pages/chatRoom_list_page.dart';
import '../pages/user_page.dart';
import '../pages/search_user_page.dart';
import '../helper/current_user_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String userUId = '';

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0)
      ..addListener(() {
        setState(() {
          switch (_tabController.index) {
            case 0:
              break;
            case 1:
              break;
          }
        });
      });

    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        userUId = user.uid;
        CurrentUserData.userId = user.uid;
        HelperFunctions.saveUserEmailSharedPreference(user.uid);
        WidgetsBinding.instance
            ?.addPostFrameCallback((_) => _getInitUserData());
      });
    });

    print('homescreen init state');
    super.initState();
  }

  _getInitUserData() async {
    CurrentUserData.userEmail =
        (await HelperFunctions.getUserEmailSharedPreference())!;
    await Firestore.instance
        .collection('users')
        .document(CurrentUserData.userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        HelperFunctions.saveUserNameSharedPreference(
            documentSnapshot.data['username']);
        HelperFunctions.saveUserImageUrlSharedPreference(
            documentSnapshot.data['image_url']);
        HelperFunctions.saveUserEmailSharedPreference(
            documentSnapshot.data['email']);
        CurrentUserData.username = documentSnapshot.data['username'];
        CurrentUserData.imageUrl = documentSnapshot.data['image_url'];
        CurrentUserData.userEmail = documentSnapshot.data['email'];
        setState(() {});
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hello, ${CurrentUserData.username}',
          style: const TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Theme.of(context).splashColor,
        elevation: 0,
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchUserPage(
                            currentUser: userUId,
                          )));
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 0),
              child: Icon(Icons.search),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(right: 15, left: 15),
              child: InkWell(
                child: const Center(
                    child: Text(
                  'Logout',
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                )),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                },
              ))
        ],
        bottom: TabBar(
          tabs: const [
            Tab(
              icon: Icon(Icons.person),
            ),
            Tab(
              icon: Icon(Icons.chat_bubble),
            ),
          ],
          indicatorColor: Colors.white,
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        children: const [
          userPage(),
          ChatRoomListPage(),
        ],
        controller: _tabController,
      ),
    );
  }
}
