import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pigeon_post/pages/language_page.dart';
import 'package:pigeon_post/providers/language_provider.dart';
import 'screens/home_screen.dart';
import './screens/login_screen.dart';
import './screens/message_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => LanguageProvider())],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pigeon Post',
      theme: ThemeData(
        primaryColor: const Color(0xff47648a), //const Color(0xFF577399),
        backgroundColor: const Color(0xfff4e2d0), //const Color(0xFF495867),
        splashColor: const Color(0xFFB0CBE8), //const Color(0xFFA2C4E2),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (ctx, snapShot) {
          if (snapShot.hasData) {
            return const HomeScreen();
            //return const MessageScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
      routes: {
        LoginScreen.routeName: (ctx) => const LoginScreen(),
        MessageScreen.routeName: (ctx) => const MessageScreen(),
        HomeScreen.routeName: (ctx) => const HomeScreen(),
        //LanguagePage.routeName: (ctx) => const LanguagePage(),
      },
    );
  }
}
