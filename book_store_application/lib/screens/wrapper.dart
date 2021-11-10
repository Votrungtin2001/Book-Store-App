import 'package:book_store_application/MVP/Model/User.dart';
import 'package:book_store_application/main_page.dart';
import 'package:book_store_application/screens/login/login_screen.dart';
import 'package:book_store_application/screens/splash/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'admin_main_page.dart';
import 'home/home_screen.dart';
import 'home_test.dart';


class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User_MD?>(context);

    // return either the Home or Authenticate widget
    if (user == null){
      return SplashScreen();
    } else {
      return MainPageAdmin();
    }

  }
}