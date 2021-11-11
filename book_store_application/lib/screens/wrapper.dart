import 'package:book_store_application/MVP/Model/User.dart';
import 'package:book_store_application/firebase/providers/user_provider.dart';
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

    final user_model = Provider.of<UserProvider>(context);
    if (user != null) {
      String user_id = "";
      if(user.uid != null) user_id = user.uid.toString();
      user_model.getUser(user_id);
      if(user.uid == "nI8SJUbcVcMOnG8bcyk0B5FAzX12") return MainPageAdmin();
      else return MainPage();
    }
    else return SplashScreen();


  }
}