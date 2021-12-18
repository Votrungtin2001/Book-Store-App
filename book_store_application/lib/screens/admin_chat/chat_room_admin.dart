import 'package:auto_size_text/auto_size_text.dart';
import 'package:book_store_application/MVP/Model/ChatRoom.dart';
import 'package:book_store_application/MVP/Model/User.dart';
import 'package:book_store_application/firebase/DatabaseManager.dart';
import 'package:book_store_application/firebase/providers/user_provider.dart';
import 'package:book_store_application/screens/admin_chat/chat_admin.dart';
import 'package:book_store_application/screens/admin_chat/search_chat_room_admin.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
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
                isSendByAdmin: snapshot.data!.docs[index]["latestMessageSendBy"] == admin_id,
                latestMessageTime: snapshot.data!.docs[index]["latestMessageTime"],

              );
            }) : Container();
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
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Center(child:Text("           Chat",style: TextStyle(color:Colors.black),)),
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SearchChatRoomAdmin()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.search,color: Colors.black,)
            ),
          )
        ],
      ),
        body: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg2.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
                children: [
                  // SizedBox(height: 85),
                  Container(
                      height: MediaQuery.of(context).size.height - 170,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              chatRoomsList(admin_id),
                            ]
                        ),
                      )
                  )
                ]
            )
        )
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String chatRoomId;
  final String admin_id;
  final List<User_Model> users;
  final String latestMessage;
  final bool isSeenByAdmin;
  final bool isSendByAdmin;
  final int latestMessageTime;
  int time = 0;
  bool isSeenByAdmin1 = false;

  ChatRoomsTile({required this.users ,required this.chatRoomId, required this.admin_id,
    required this.latestMessage, required this.isSeenByAdmin, required this.isSendByAdmin,
    required this.latestMessageTime});

  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    isSeenByAdmin1 = isSendByAdmin;
    User_Model user = new User_Model('', '', 1, '', '', '', '', '');
    for(int i = 0; i < users.length; i++) {
      if(users[i].getID() == chatRoomId) {
        user = users[i];
      }
    }
    String displayLatestMessage = "";
    if(isSendByAdmin == true) displayLatestMessage = "You: " + latestMessage;
    else displayLatestMessage = latestMessage;
    String timeAgo = calculateTimeAgoSinceDate(latestMessageTime);
    time = latestMessageTime;
    if(time == 0) {
      isSeenByAdmin1 = true;
      timeAgo = "";
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
        padding: EdgeInsets.only(left: 24, right: 24, top: 15, bottom: 15),

        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: Image.network(user.getPhoto(), fit: BoxFit.fill).image,
              maxRadius: 30,
            ),
            SizedBox(width: 20,),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    user.getName(),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    )
                ),
                SizedBox(height: 5,),
                Container(
                  width: 100,
                  child: Text(
                    displayLatestMessage,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: TextStyle(
                      fontSize: 15,
                      color: isSeenByAdmin
                          ? Colors.grey.shade600
                          : Colors.black,
                      fontWeight: isSeenByAdmin ? FontWeight.w300 : FontWeight.w700 ,
                    ),
                  ),
                )
              ],
            ),
            Spacer(),
            Row(
              children: [
                Text(
                    timeAgo,
                  style: TextStyle(
                    fontWeight: isSeenByAdmin  ? FontWeight.w300 : FontWeight.w700
                  ),
                ),
                SizedBox(width: 5,),
                Image.asset(
                  "assets/images/circle.png",
                  height: 10,
                  width: 10 ,
                  color: isSeenByAdmin1 ? Colors.transparent : Colors.red,
                ),
              ],
            )

          ],
        ),
      )
    );
  }

  String calculateTimeAgoSinceDate(int time) {
    DateTime notificationDate = DateTime.fromMillisecondsSinceEpoch(time);
    final date2 = DateTime.now();
    final diff = date2.difference(notificationDate);

    if(diff.inDays > 8) return DateFormat("dd/MM/yyyy HH:mm:ss").format(notificationDate);
    else if((diff.inDays / 7).floor() >= 1) return "last week";
    else if(diff.inDays >= 2) return '${diff.inDays} days ago';
    else if(diff.inDays >= 1) return "1 day ago";
    else if(diff.inHours >= 2) return '${diff.inHours} hours ago';
    else if(diff.inHours >= 1) return "1 hour ago";
    else if(diff.inMinutes >= 2) return '${diff.inMinutes} minutes ago';
    else if(diff.inMinutes >= 1) return "1 minute ago";
    else if(diff.inSeconds >= 3) return '${diff.inSeconds} seconds ago';
    else return "Just now";
  }
}



