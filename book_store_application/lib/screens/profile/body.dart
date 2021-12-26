import 'package:book_store_application/MVP/Presenter/accoutAdministration_presenter.dart';
import 'package:book_store_application/MVP/View/accountAdministration_view.dart';
import 'package:book_store_application/firebase/authentication_services.dart';
import 'package:book_store_application/firebase/providers/user_provider.dart';
import 'package:book_store_application/screens/about_us/about_us_screen.dart';
import 'package:book_store_application/screens/change_password/change_password_screen.dart';
import 'package:book_store_application/screens/favourite/myfavourite_screen.dart';
import 'package:book_store_application/screens/home/home_screen.dart';
import 'package:book_store_application/screens/login/login_screen.dart';
import 'package:book_store_application/screens/my_orders/my_orders_screen.dart';
import 'package:book_store_application/screens/profile/profile_ava.dart';
import 'package:book_store_application/screens/profile/profile_menu.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'edit_profile_screen.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> implements AccountAdministrationView {
  final DatabaseReference refFavorite = FirebaseDatabase.instance.reference().child('Favorites');
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthenticationServices _auth = AuthenticationServices();
  late AccountAdministrationPresenter presenter;

  _BodyState() {
    this.presenter = new AccountAdministrationPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    final user_model = Provider.of<UserProvider>(context);
    String photo = user_model.user.getPhoto();
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 20),
      child:Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg2.png"),
              fit: BoxFit.cover,
            ),
          ),
      child: Column(
        children: [
          getAppBarUI(),
          SizedBox(
            height: 130,
            width: 130,
            child: Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  backgroundImage: Image.network(photo, fit: BoxFit.fill).image,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height - 100,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
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
                        press: () async {
                          List<int> favorites = [];
                          await refFavorite.child(user_model.user.getID()).child('book_id').once().then((DataSnapshot snapshot){
                            Map<String, dynamic> json = Map.from(snapshot.value);
                            json.forEach((key, value) {
                              int book_id = int.parse(value.toString());
                              favorites.add(book_id);
                            });
                          });
                          Navigator.push<dynamic>(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) => MyFavouriteScreen(favorites),
                            ),
                          );
                        },
                      ),
                      ProfileMenu(
                        text: "Change Password",
                        icon: "assets/icons/Lock.svg",
                        press: () {
                          Navigator.push<dynamic>(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) => ChangePasswordScreen(),
                            ),
                          );
                        },
                      ),
                      ProfileMenu(
                        text: "About Us",
                        icon: "assets/icons/Question.svg",
                        press: () {
                          Navigator.push<dynamic>(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) => AboutUsScreen(),
                            ),
                          );
                        },
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
                ),
              )
        ],
      )
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
