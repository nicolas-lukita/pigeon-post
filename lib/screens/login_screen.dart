import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pigeon_post/services/database_functions.dart';
import '../widgets/login_form.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../helper/helper_functions.dart';
import '../helper/current_user_data.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const routeName = '/login-screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitLoginForm(String email, String username, String password,
      File image, bool isLogin, BuildContext ctx) async {
    AuthResult authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      //login function
      if (isLogin) {
        //submit login function
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password); //login with email and password
        FirebaseUser user = authResult.user;
        String userUid = user.uid;

        //get user document
        QuerySnapshot userInfoSnapshot =
            await DatabaseFunctions().searchByUserEmail(email);
        //save current logged in user data in shared preference
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        HelperFunctions.saveUserEmailSharedPreference(
            userInfoSnapshot.documents[0].data["email"]);
        HelperFunctions.saveUserNameSharedPreference(
            userInfoSnapshot.documents[0].data["username"]);
        CurrentUserData.username =
            userInfoSnapshot.documents[0].data["username"];
        CurrentUserData.userEmail = userInfoSnapshot.documents[0].data["email"];
      } else {
        //sign up function
        //submit create new account function
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password); //create new account

        //preparing user's profile image
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(authResult.user.uid + '.jpg');

        await ref.putFile(image).onComplete;
        final url = await ref.getDownloadURL();

        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({
          'username': username,
          'email': email,
          'image_url': url,
        }); //store data in users collection database

        //locally store data in shared preference
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        HelperFunctions.saveUserEmailSharedPreference(email);
        HelperFunctions.saveUserNameSharedPreference(username);
        CurrentUserData.username = username;
        CurrentUserData.userEmail = email;
      }
    } on PlatformException catch (err) {
      var message = 'An error occured, please check your credentials!';

      if (err.message != null) {
        message = err.message!;
      }

      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).errorColor,
      ));

      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      debugPrint('$err');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/login-img.jpg'),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent, 
        body: LoginForm(
          _submitLoginForm,
          _isLoading,
        ),
      ),
    );
  }
}
