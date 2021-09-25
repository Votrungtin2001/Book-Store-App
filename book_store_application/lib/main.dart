import 'package:book_store_application/screens/home/home_screen.dart';
import 'package:book_store_application/screens/start/start_screen.dart';
import 'package:book_store_application/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:book_store_application/screens/splash/splash_screen.dart';
import 'package:book_store_application/constants.dart';
import 'package:book_store_application/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'MVP/Model/User.dart';
import 'firebase/authentication_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

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
    return StreamProvider<User_MD?>.value(
      initialData: null,
      catchError: (_, err) => null,
      value: AuthenticationServices().user,
      child: MaterialApp(
        home: Wrapper(),
        debugShowCheckedModeBanner: false,
        title: 'Book Store App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }
    /*return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Book Store App',
        theme: ThemeData(
           primarySwatch: Colors.blue,
           visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // home: isLoggedIn ? StartScreen() : SplashScreen()
      home: HomeScreen()
    );


  }*/
}