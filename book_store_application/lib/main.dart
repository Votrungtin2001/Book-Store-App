import 'package:book_store_application/screens/home/home_screen.dart';
import 'package:book_store_application/screens/start/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:book_store_application/screens/splash/splash_screen.dart';
import 'package:book_store_application/constants.dart';
import 'package:book_store_application/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  MyAppState() {
    MySharedPreferences.instance
        .getBooleanValue("isfirstRun")
        .then((value) =>
        setState(() {
          isLoggedIn = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Book Store App',
        theme: ThemeData(
           primarySwatch: Colors.blue,
           visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // home: isLoggedIn ? StartScreen() : SplashScreen()
      home: HomeScreen()
    );


  }
}