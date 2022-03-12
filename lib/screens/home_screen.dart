import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pigeon_post/helper/helper_functions.dart';
import 'package:pigeon_post/pages/user_page.dart';
import '../widgets/friend_tile.dart';
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
    // TODO: implement initState
    super.initState();
    _tabController =
        TabController(length: 2 /*4*/, vsync: this, initialIndex: 1)
          ..addListener(() {
            setState(() {
              switch (_tabController.index) {
                case 0:
                  break;
                case 1:
                  break;
                // case 2:
                //   break;
                // case 3:
                //   break;
              }
            });
          });
    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        userUId = user.uid;
        CurrentUserData.userId = user.uid;
      });
    });
  }

  getCurrentUserData() async {
    CurrentUserData.username =
        (await HelperFunctions.getUserNameSharedPreference())!;
    CurrentUserData.userEmail =
        (await HelperFunctions.getUserEmailSharedPreference())!;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getCurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Friends List',
          style: TextStyle(
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
              icon: Icon(Icons.camera_alt),
            ),
            Tab(
              child: Text("Chats"),
            ),
            // Tab(
            //   child: Text("Status"),
            // ),
            // Tab(
            //   child: Text("Calls"),
            // )
          ],
          indicatorColor: Colors.white,
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        children: [
          Icon(Icons.camera_alt),
          userPage(
            currentUser: userUId,
          ),
          // Text('Status Screen'),
          // Text('Call Screen')
        ],
        controller: _tabController,
      ),
      // body: UserSearchPage(//userPage(
      //   currentUser: userUId,
    );
  }
}
