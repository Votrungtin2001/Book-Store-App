// import 'package:book_store_application/firebase/providers/default_waitingOrders_provider.dart';
// import 'package:book_store_application/screens/admin_profile/ProfileAdmin.dart';
//
// import 'package:book_store_application/screens/profile/profile_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//

// import 'admin_chat/chat_room_admin.dart';
// import 'admin_edit_books/edit_book_screen.dart';
// import 'admin_home/home_screen_admin.dart';
//
//
// class MainPageAdmin extends StatefulWidget {
//   const MainPageAdmin({Key? key}) : super(key: key);
//
//   @override
//   _MainPageAdminState createState() => _MainPageAdminState();
// }
//
// enum BottomIcons { Explore, Book , Message, Account }
//
// class _MainPageAdminState extends State<MainPageAdmin> {
//   BottomIcons bottomIcons = BottomIcons.Explore;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Stack(
//         children: <Widget>[
//           bottomIcons == BottomIcons.Explore
//               ? HomeScreenAdmin()
//               : Container(),
//           bottomIcons == BottomIcons.Message
//               ? ChatRoomAdmin()
//               : Container(),
//           bottomIcons == BottomIcons.Book
//               ? const EditBookScreen()
//               : Container(),
//           bottomIcons == BottomIcons.Account
//               ? const ProfileAdmin()
//               : Container(),
//           Align(
//             alignment: Alignment.bottomLeft,
//             child: Container(
//               padding: const EdgeInsets.only(left: 24, right: 24, bottom: 30),
//               color: Colors.white,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   BottomBar(
//                       onPressed: () {
//                         setState(() {
//                           bottomIcons = BottomIcons.Explore;
//                         });
//                       },
//                       bottomIcons: bottomIcons == BottomIcons.Explore ? true : false,
//                       icons: Icons.explore_outlined,
//                       text: "Explore"),
//                   BottomBar(
//                       onPressed: () {
//                         setState(() {
//                           bottomIcons = BottomIcons.Message;
//                         });
//                       },
//                       bottomIcons: bottomIcons == BottomIcons.Message ? true : false,
//                       icons: Icons.chat_bubble_outline_outlined,
//                       text: "Chat"),
//                   BottomBar(
//                       onPressed: () {
//                         setState(() {
//                           bottomIcons = BottomIcons.Book;
//                         });
//                       },
//                       bottomIcons: bottomIcons == BottomIcons.Book ? true : false,
//                       icons: Icons.add,
//                       text: "Add Book"),
//                   BottomBar(
//                       onPressed: () {
//                         setState(() {
//                           bottomIcons = BottomIcons.Account;
//                         });
//                       },
//                       bottomIcons: bottomIcons == BottomIcons.Account ? true : false,
//                       icons: Icons.account_circle_outlined,
//                       text: "Account"),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
