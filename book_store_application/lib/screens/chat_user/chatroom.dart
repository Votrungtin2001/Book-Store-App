import 'package:book_store_application/MVP/Model/User.dart';
import 'package:book_store_application/firebase/providers/user_provider.dart';
import 'package:book_store_application/screens/chat_user/search.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat.dart';
import 'constants.dart';
import 'database.dart';
import 'helperfunctions.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  Stream<QuerySnapshot>? chatRoom;
  final FirebaseAuth auth = FirebaseAuth.instance;
  User_Model user_model = new User_Model('', '', 1, '', '', '', '', '');

  Widget chatRoomsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: chatRoom,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
            itemCount: snapshot.data!.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ChatRoomsTile(
                userName: snapshot.data!.docs[index]['chatRoomId']
                     .toString()
                     .replaceAll("_", "")
                     .replaceAll(auth.currentUser!.displayName.toString(), ""),
                chatRoomId:snapshot.data!.docs[index]["chatRoomId"] ,
              );
            })
            : Container(child: Text("Bạn chưa chat với ai"),);
      },
    );
  }

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }
  List<User_Model> users = [];

  getUserInfogetChats() async {
   // Constants.myName = (await HelperFunctions.getUserNameSharedPreference())!;
    DatabaseMethods().getUserChats(auth.currentUser!.displayName.toString()).then((snapshots) {
      setState(() {
        chatRoom = snapshots;
        print(
            "we got the data + ${chatRoom.toString()} this is name  ${Constants.myName}");
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Icon(Icons.ten_k),
        elevation: 0.0,
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Search()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.search)
            ),
          )
        ],
      ),
      body: Container(
        child: chatRoomsList(),
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({required this.userName, required this.chatRoomId});

  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final user_model = Provider.of<UserProvider>(context);
    String name = user_model.user.getID();
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Chat(
              chatRoomId: chatRoomId,
            )
        ));
      },
      child: Container(
        color: Colors.blue,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color:  Colors.amber,
                  borderRadius: BorderRadius.circular(30)
              ),
              child: Text(
                  userName.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w300)),
            ),
            SizedBox(width: 12,),
            Text(
                userName,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w300)
            )
          ],
        ),
      ),
    );
  }
}


