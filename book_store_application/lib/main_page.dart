
import 'package:book_store_application/screens/chat_user/chat.dart';
import 'package:book_store_application/screens/chat_user/chatroom.dart';
import 'package:book_store_application/screens/home/home_screen.dart';
import 'package:book_store_application/screens/profile/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:book_store_application/bottom_nav_bar.dart';
import 'package:provider/provider.dart';

import 'firebase/providers/user_provider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

enum BottomIcons { Explore, Message, Notification, Account }

class _MainPageState extends State<MainPage> {
  BottomIcons bottomIcons = BottomIcons.Explore;

  @override
  Widget build(BuildContext context) {
    final user_model = Provider.of<UserProvider>(context);
    String user_id = user_model.user.getID();
    return Scaffold(
      body: Stack(
        children: <Widget>[
          bottomIcons == BottomIcons.Explore
              ? HomeScreen()
              : Container(),
          bottomIcons == BottomIcons.Message
              ? Chat(chatRoomId: user_id, user_id: user_id,)
              : Container(),
          bottomIcons == BottomIcons.Account
              ? const ProfileScreen()
              : Container(),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 30),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  BottomBar(
                      onPressed: () {
                        setState(() {
                          bottomIcons = BottomIcons.Explore;
                        });
                      },
                      bottomIcons: bottomIcons == BottomIcons.Explore ? true : false,
                      icons: Icons.explore_outlined,
                      text: "Explore"),
                  BottomBar(
                      onPressed: () {
                        setState(() {
                          bottomIcons = BottomIcons.Message;
                        });
                      },
                      bottomIcons: bottomIcons == BottomIcons.Message ? true : false,
                      icons: Icons.chat_bubble_outline_outlined,
                      text: "Chat"),
                  BottomBar(
                      onPressed: () {
                        setState(() {
                          bottomIcons = BottomIcons.Account;
                        });
                      },
                      bottomIcons: bottomIcons == BottomIcons.Account ? true : false,
                      icons: Icons.account_circle_outlined,
                      text: "Account"),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}