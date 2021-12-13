import 'package:book_store_application/MVP/Model/ChatRoom.dart';
import 'package:book_store_application/MVP/Model/User.dart';
import 'package:book_store_application/firebase/DatabaseManager.dart';
import 'package:book_store_application/firebase/providers/user_provider.dart';
import 'package:book_store_application/screens/admin_chat/chat_admin.dart';
import 'package:book_store_application/screens/admin_chat/search_chat_room_admin.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatRoomAdmin extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoomAdmin> {

  Stream<QuerySnapshot>? chatRoom;
  final FirebaseAuth auth = FirebaseAuth.instance;
  User_Model user_model = new User_Model('', '', 1, '', '', '', '', '');
  DatabaseManager database = new DatabaseManager();

  List<User_Model> users = [];

  Widget chatRoomsList(String admin_id) {
    return StreamBuilder<QuerySnapshot>(
      stream: chatRoom,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
            itemCount: snapshot.data!.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ChatRoomsTile(
                users: users,
                chatRoomId:snapshot.data!.docs[index]["chatRoomID"] ,
                admin_id: admin_id,
                latestMessage: snapshot.data!.docs[index]["latestMessage"],
                isSeenByAdmin: snapshot.data!.docs[index]["isSeenByAdmin"],
              );
            })
            : Container(child: Text("Bạn chưa chat với ai"),);
      },
    );
  }

  @override
  void initState() {
    getUsers();
    getChatRooms();
    super.initState();
  }

  getChatRooms() async {
    database.getChatRooms().then((snapshots) {
      setState(() {
        chatRoom = snapshots;
      });
    });
  }

  getUsers() async {
    database.getUsers().then((snapshots) {
      List<User_Model> list = [];
      for (DocumentSnapshot user in snapshots.docs) {
        list.add(User_Model.fromSnapshot(user));
      }
      setState(() {
        users = list;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    final user_model = Provider.of<UserProvider>(context);
    String admin_id = user_model.user.getID();
    return Scaffold(
      appBar: AppBar(
        title: Icon(Icons.ten_k),
        elevation: 0.0,
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SearchChatRoomAdmin()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.search)
            ),
          )
        ],
      ),
      body: Container(
        child: chatRoomsList(admin_id),
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String chatRoomId;
  final String admin_id;
  final List<User_Model> users;
  final String latestMessage;
  final bool isSeenByAdmin;

  ChatRoomsTile({required this.users ,required this.chatRoomId, required this.admin_id,
    required this.latestMessage, required this.isSeenByAdmin});

  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    User_Model user = new User_Model('', '', 1, '', '', '', '', '');
    for(int i = 0; i < users.length; i++) {
      if(users[i].getID() == chatRoomId) {
        user = users[i];
      }
    }

    return GestureDetector(
      onTap: (){
        DatabaseManager().seen(chatRoomId);
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ChatAdmin(
              chatRoomId: chatRoomId,
              admin_id: admin_id,
              user: user,
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
                  user.getName(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w300)),
            ),
            SizedBox(width: 12,),
            Text(
                user.getName(),
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



