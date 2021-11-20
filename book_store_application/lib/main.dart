import 'package:book_store_application/firebase/providers/books_provider.dart';
import 'package:book_store_application/firebase/providers/default_waitingOrders_provider.dart';
import 'package:book_store_application/screens/splash/splash_screen.dart';
import 'package:book_store_application/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:book_store_application/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import 'MVP/Model/User.dart';
import 'firebase/authentication_services.dart';
import 'firebase/providers/author_provider.dart';
import 'firebase/providers/category_provider.dart';
import 'firebase/providers/order_provider.dart';
import 'firebase/providers/publisher_provider.dart';
import 'firebase/providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: BooksProvider.initialize()),
      ChangeNotifierProvider.value(value: CategoryProvider.initialize()),
      ChangeNotifierProvider.value(value: AuthorProvider.initialize()),
      ChangeNotifierProvider.value(value: PublisherProvider.initialize()),
      ChangeNotifierProvider.value(value: OrderProvider.initialize()),
      ChangeNotifierProvider.value(value: UserProvider.initialize()),
      ChangeNotifierProvider.value(value: DefaultWaitingOrderProvider.initialize()),
    ],
    child: const MyApp(),
  ));
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
    //..customAnimation = CustomAnimation();
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
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
        title: 'Book Store App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }
}