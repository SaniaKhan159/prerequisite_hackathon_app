import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prerequisite_hackathon_app/view/favorite_news.dart';
import 'package:prerequisite_hackathon_app/view/home.dart';
import 'package:prerequisite_hackathon_app/view/login.dart';
import 'package:prerequisite_hackathon_app/view/news_search.dart';
import 'package:prerequisite_hackathon_app/view/profile.dart';
import 'package:prerequisite_hackathon_app/view/register.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpoverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Container();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primaryColor: Colors.white,
            ),
            home: Home(),
            routes: {
              "/login": (context) => Login(),
              "/register": (context) => Register(),
              "/search": (context) => NewsSearch(),
              "/favorite": (context) => FavoriteNews(),
              "/profile": (context) => Profile(),
            },
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Container();
      },
    );
  }
}

class MyHttpoverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
