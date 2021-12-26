import 'package:flutter/material.dart';

class FriendScreen extends StatelessWidget {
  const FriendScreen({Key? key}) : super(key: key);
  static const routeName = '/friend-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Friend List',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xfff4e2d0),
        elevation: 0,
      ),
      body: Container(
        color: const Color(0xfff4e2d0),
        child: Column(
          children: <Widget>[
            const Card(
              child: Text('card widget'),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (ctx, index) {
                    return Container(
                      child: Text(index.toString()),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
