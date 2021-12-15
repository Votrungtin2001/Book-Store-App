import 'package:book_store_application/MVP/Model/User.dart';
import 'package:book_store_application/firebase/DatabaseManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatAdmin extends StatefulWidget {
  final String chatRoomId;
  final String admin_id;
  final User_Model user;
  ChatAdmin({required this.chatRoomId, required this.admin_id, required this.user});

  @override
  _ChatAdminState createState() => _ChatAdminState(this.chatRoomId, this.admin_id, this.user);
}

class _ChatAdminState extends State<ChatAdmin> {

  Stream<QuerySnapshot>? chats;
  TextEditingController messageEditingController = new TextEditingController();
  String chatRoomId = "";
  String admin_id = "";
  User_Model user = new User_Model('', '', 1, '', '', '', '', '');
  DatabaseManager database = new DatabaseManager();

  _ChatAdminState(String chatRoomID, String adminID, User_Model User) {
    this.chatRoomId = chatRoomID;
    this.admin_id = adminID;
    this.user = User;
  }

  Widget chatMessages(){
    return StreamBuilder<QuerySnapshot>(
      stream: chats,
      builder: (context, snapshot){
        return snapshot.hasData ?  ListView.builder(
          scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index){
              return MessageTile(
                message: snapshot.data!.docs[index]["message"],
                sendByMe: admin_id == snapshot.data!.docs[index]["sendBy"],
              );
            }) : Container(child: Text("Banj chuaw nhan gi "));
      },
    );
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      int time = DateTime.now().millisecondsSinceEpoch;
      Map<String, dynamic> chatMessageMap = {
        "sendBy": admin_id,
        "message": messageEditingController.text,
        'time': time,
      };

      database.addMessage(chatRoomId, chatMessageMap, messageEditingController.text, time, true);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    database.getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(user.getPhoto()),
                  maxRadius: 25,
                ),
                SizedBox(width: 12,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        user.getName(),
                        style: TextStyle(

                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),

                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
      body: Container(
        child:Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height - 115,
                child: chatMessages(),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: EdgeInsets.only(left: 16, bottom: 10),
                  height: 70,
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: messageEditingController,
                          decoration: InputDecoration(
                              hintText: "Type message...",
                              hintStyle: TextStyle(color: Colors.grey.shade500),
                              border: InputBorder.none
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding: EdgeInsets.only(right: 30, bottom: 40),
                  child: FloatingActionButton(
                    onPressed: () {
                      addMessage();
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.pink.shade300,
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }

}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({required this.message, required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
          padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
          decoration: BoxDecoration(
            borderRadius: sendByMe ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ) : BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)),
            color: sendByMe ? Colors.white : Colors.pink.shade100,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Text(
              message,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500)
          ),
        ),
        SizedBox(height: 10,),

        //isLastMessageLeft
           // ?
        Container(
          child: Text("19h20",
            style: TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic,fontWeight: FontWeight.w600),
          ),

        )
        //    : SizedBox.shrink()

      ],
    ) 
       
    );
  }
}
