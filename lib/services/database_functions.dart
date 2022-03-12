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

  searchByUserEmail(String email) {
    return Firestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .getDocuments()
        .catchError((e) {
          print(e);
        });
  }

  Future<bool> checkChatRoomExistance(String chatRoomId) async {
    try {
      var collectionRef = Firestore.instance.collection('chatRoom');
      var doc = await collectionRef.document(chatRoomId).get();
      return doc.exists;
      } catch (e) {
        throw e;
      }
  }
}
