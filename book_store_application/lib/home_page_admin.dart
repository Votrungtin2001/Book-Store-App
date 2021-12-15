import 'package:book_store_application/screens/admin_chat/chat_room_admin.dart';
import 'package:book_store_application/screens/admin_edit_books/edit_book_screen.dart';
import 'package:book_store_application/screens/admin_home/home_screen_admin.dart';
import 'package:book_store_application/screens/admin_profile/ProfileAdmin.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class HomePageAdmin extends StatefulWidget {
  @override
  _HomePageAdminState createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {

  int _page = 0;
  @override
  Widget build(BuildContext context) {

    List<Widget> _body = [
      HomeScreenAdmin(),
      ChatRoomAdmin(),
      EditBookScreen(),
      ProfileAdmin()
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
        color: Color.fromRGBO(149, 227, 253, 1.0),
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.white,
        height: 70.0,
        items: <Widget>[
          Icon(
            Icons.home,
            size: 30.0,
            color: Colors.blueAccent,
          ),

          Icon(
            Icons.chat_bubble,
            size: 30.0,
            color: Colors.blueAccent,
          ),
          Icon(
            Icons.add,
            size: 30.0,
            color: Colors.blueAccent,
          ),
          Icon(
            Icons.account_circle,
            size: 30.0,
            color: Colors.blueAccent,
          ),
        ],
        onTap: (index) {
          setState(
                () {
              _page = index;
            },
          );
        },
      ),

      body: _body[_page],
    );
  }
}