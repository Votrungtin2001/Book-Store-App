import 'package:book_store_application/screens/chat_user/chat.dart';
import 'package:book_store_application/screens/home/home_screen.dart';
import 'package:book_store_application/screens/profile/profile_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase/providers/user_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _page = 0;
  @override
  Widget build(BuildContext context) {
    final user_model = Provider.of<UserProvider>(context);
    String user_id = user_model.user.getID();
    List<Widget> _body = [
      HomeScreen(),
      Chat(chatRoomId: user_id, user_id: user_id, user_name: "Bibliphiole",),
    //  ProfileScreen()
      ProfileScreen(),
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
            Icons.account_circle,
            size: 30.0,
            color: Colors.blueAccent,
          ),
        ],
        onTap: (index) {
          setState(() {
              _page = index;
            },
          );
        },
      ),

      body: _body[_page],
    );
  }
}