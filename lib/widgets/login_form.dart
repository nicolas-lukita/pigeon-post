import 'package:flutter/material.dart';
import './user_image_picker.dart';
import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';

class LoginForm extends StatefulWidget {
  LoginForm(this.submitFn, this.isLoading);

  final bool isLoading;
  final void Function(String email, String username, String password,
      File image, bool isLogin, BuildContext ctx) submitFn;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final _formKey = GlobalKey<FormState>();

  File? _userImageFile = File('');
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  var _isLogin = true;
  //check if login state or create new account state
  //true = login, false = create new account

  void _submitForm() {
    final isValid = _formKey.currentState!.validate(); //validate all form input
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: const Text('Please pick an image'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }

    if (isValid) {
      _formKey.currentState!
          .save(); //call all onSaved function of TextFormField
      widget.submitFn(_userEmail.trim(), _userName.trim(), _userPassword.trim(),
          _userImageFile!, _isLogin, context);
    }
  }

  void _submitImage(File image) {
    _userImageFile = image;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        //shape:
        //    RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        color: Colors.transparent, //const Color(0xFFfaf8f5).withOpacity(0.8),
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 23),
          child: Form(
              //autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(children: <Widget>[
                if (_isLogin)
                  const SizedBox(
                    width: 250,
                    child: Image(image: AssetImage('assets/pigeon-logo.png')),
                  ),
                const SizedBox(
                  height: 10,
                ),
                if (!_isLogin)
                  UserImagePicker(
                    imagePickFn: _submitImage,
                  ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  style: const TextStyle(fontSize: 18),
                  key: const ValueKey('email'),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white70,
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
                    errorBorder: OutlineInputBorder(
                        gapPadding: 10,
                        borderRadius: BorderRadius.circular(50),
                        borderSide: const BorderSide(
                          color: Colors.red,
                        )),
                    focusedErrorBorder: OutlineInputBorder(
                        gapPadding: 10,
                        borderRadius: BorderRadius.circular(50),
                        borderSide: const BorderSide(
                          color: Colors.red,
                        )),
                    border: InputBorder.none,
                    hintText: 'Email address',
                    prefixIcon: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(Icons.mail)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _userEmail = value!;
                  },
                ),
                if (!_isLogin)
                  const SizedBox(
                    height: 15,
                  ),
                if (!_isLogin)
                  TextFormField(
                      style: const TextStyle(fontSize: 18),
                      key: const ValueKey('username'),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white70,
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
                          errorBorder: OutlineInputBorder(
                              gapPadding: 10,
                              borderRadius: BorderRadius.circular(50),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              )),
                          focusedErrorBorder: OutlineInputBorder(
                              gapPadding: 10,
                              borderRadius: BorderRadius.circular(50),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              )),
                          hintText: 'Username',
                          border: InputBorder.none,
                          prefixIcon: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Icon(Icons.person))),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userName = value!;
                      }),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                    key: const ValueKey('password'),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white70,
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
                        errorBorder: OutlineInputBorder(
                            gapPadding: 10,
                            borderRadius: BorderRadius.circular(50),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            )),
                        focusedErrorBorder: OutlineInputBorder(
                            gapPadding: 10,
                            borderRadius: BorderRadius.circular(50),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            )),
                        hintText: 'Password',
                        border: InputBorder.none,
                        prefixIcon: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Icon(Icons.lock))),
                    obscureText: true,
                    validator: (value) {
                      if (value!.length < 4 || value.isEmpty) {
                        return 'Please enter at least 4 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userPassword = value!;
                    }),
                const SizedBox(
                  height: 25,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(150, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        textStyle: const TextStyle(fontSize: 18),
                        primary: Theme.of(context).primaryColor,
                        onPrimary: Colors.white),
                    child: Text((_isLogin) ? 'Login' : 'Submit'),
                    onPressed: _submitForm,
                  ),
                ),
                TextButton(
                    style: TextButton.styleFrom(
                        primary: Theme.of(context).primaryColor),
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin; //flip login/create account state
                      });
                    },
                    child: Text(
                        (_isLogin)
                            ? 'Create a new account'
                            : 'I already have an account',
                        style: const TextStyle(color: Colors.white, fontSize: 17))),
              ])),
        ),
      ),
    );
  }
}
