import 'package:book_store_application/MVP/Presenter/accoutAdministration_presenter.dart';
import 'package:book_store_application/MVP/View/accountAdministration_view.dart';
import 'package:book_store_application/firebase/authentication_services.dart';
import 'package:book_store_application/screens/favourite/myfavourite_screen.dart';
import 'package:book_store_application/screens/home/home_screen.dart';
import 'package:book_store_application/screens/login/login_screen.dart';
import 'package:book_store_application/screens/my_orders/my_orders_screen.dart';
import 'package:book_store_application/screens/profile/profile_ava.dart';
import 'package:book_store_application/screens/profile/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'edit_profile_screen.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> implements AccountAdministrationView {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthenticationServices _auth = AuthenticationServices();
  late AccountAdministrationPresenter presenter;

  _BodyState() {
    this.presenter = new AccountAdministrationPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          getAppBarUI(),
          ProfileAvatar(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "My Account",
            icon: "assets/icons/account.svg",
            press: () {
              Navigator.push<dynamic>( context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => EditProfileScreen(),
                ),
              );
            },
          ),
          ProfileMenu(
            text: "My Orders",
            icon: "assets/icons/shopping_bag.svg",
            press: () {
              Navigator.push<dynamic>( context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => MyOrdersScreen(),
                ),
              );
            },
          ),
          ProfileMenu(
            text: "My Favourite",
            icon: "assets/icons/heart.svg",
            press: () {
              Navigator.push<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => MyFavouriteScreen(),
                ),
              );
            },
          ),
          ProfileMenu(
            text: "Settings",
            icon: "assets/icons/Settings.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Help Center",
            icon: "assets/icons/Question mark.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Log Out",
            icon: "assets/icons/Log out.svg",
            press: () {
              presenter.logOut();
              Fluttertoast.showToast(msg: 'Logged out successfully.', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
        ],
      ),
    );
  }
  Widget getAppBarUI() {
    return Container(
      width: AppBar().preferredSize.height + 40,
      height: AppBar().preferredSize.height,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.only( left: 5, right: 5),
        child: Row(
          children: const <Widget>[
            Expanded(
              child: Center(
                child: Text(
                  'Profile',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  @override
  Future<void> logOut() async {
    dynamic result = await _auth.signOut();
  }
}
