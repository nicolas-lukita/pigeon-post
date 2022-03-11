import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseFunctions {
  searchByUsername(String username) {
    return Firestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .getDocuments()
        .catchError((e) {
      print(e);
    });
  }
}
