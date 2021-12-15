import 'package:book_store_application/MVP/Model/User.dart';
import 'package:book_store_application/firebase/DatabaseManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';


class Chat extends StatefulWidget {
  final String chatRoomId;
  final String user_id;
  final String user_name;

  Chat({required this.chatRoomId, required this.user_id, required this.user_name});

  @override
  _ChatState createState() => _ChatState(this.chatRoomId, this.user_id, this.user_name);
}

class _ChatState extends State<Chat> {

  Stream<QuerySnapshot>? chats;
  TextEditingController messageEditingController = new TextEditingController();
  String chatRoomId = "";
  String user_id = "";
  String user_name = "";


  DatabaseManager database = new DatabaseManager();
  String latestMessageUserID = "";

  _ChatState(String chatRoomID, String userID, String userName) {
    this.chatRoomId = chatRoomID;
    this.user_id = userID;
    this.user_name = userName;

  }

  Widget chatMessages(){
    String id = latestMessageUserID;
    return StreamBuilder<QuerySnapshot>(
      stream: chats,
      builder: (context, snapshot){
        return snapshot.hasData ?  ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index){
              bool isDisplayTime = false;
              if(index == snapshot.data!.docs.length - 1) {
                isDisplayTime = true;
              }
              else{
                if(id == snapshot.data!.docs[index]["sendBy"] && id != snapshot.data!.docs[index+1]["sendBy"]){
                  isDisplayTime = true;
                  id = snapshot.data!.docs[index+1]["sendBy"];
                }
              }

              return MessageTile(
                message: snapshot.data!.docs[index]["message"],
                sendByMe: user_id == snapshot.data!.docs[index]["sendBy"],
                time: snapshot.data!.docs[index]["time"],
                isDisplayTime: isDisplayTime,
              );
            }) : Container();
      },
    );
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      int time = DateTime.now().millisecondsSinceEpoch;
      Map<String, dynamic> chatMessageMap = {
        "sendBy": user_id,
        "message": messageEditingController.text,
        'time': time,
      };

      database.addMessage(chatRoomId, chatMessageMap, messageEditingController.text, time, false, user_id, false);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chatRoomId)
        .collection("Chat")
        .orderBy('time')
        .get().then(((result) {
      String id = result.docs[0].get("sendBy");
      setState(() {
        latestMessageUserID = id;
      });
    }));

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
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 70,
          child: Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height - 100,
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
                                border: InputBorder.none),
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
                )

              ],
            ),
        ),
      )
    );
  }

}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final int time;
  final bool isDisplayTime;
  MessageTile({required this.message, required this.sendByMe, required this.isDisplayTime, required this.time, });


  @override
  Widget build(BuildContext context) {
    return
      Container(
      padding: EdgeInsets.only(top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        children:[
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
                  bottomRight: Radius.circular(23)
              ),
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
          isDisplayTime
              ?
          Container(
            child: Text("19h20",
              style: TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic,fontWeight: FontWeight.w600),
            ),

          )
              : SizedBox.shrink()

        ],



     )

   );
  }
}
