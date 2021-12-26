import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/login_form.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const routeName = '/login-screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    void _submitLoginForm(String email, String username, String password,
        bool isLogin, BuildContext ctx) async {
      AuthResult authResult;

      try {
        setState(() {
          _isLoading = true;
        });
        if (isLogin) {
          //submit login function
          authResult = await _auth.signInWithEmailAndPassword(
              email: email, password: password); //login with email and password
        } else {
          //submit create new account function
          authResult = await _auth.createUserWithEmailAndPassword(
              email: email, password: password); //create new account

          await Firestore.instance
              .collection('users')
              .document(authResult.user.uid)
              .setData({
            'username': username,
            'email': email,
          }); //store data in users collection database
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
        print(err);
        setState(() {
          _isLoading = false;
        });
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: LoginForm(
        _submitLoginForm,
        _isLoading,
      ),
    );
  }
}
