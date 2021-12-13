import 'package:book_store_application/firebase/DatabaseManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


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

  _ChatState(String chatRoomID, String userID, String userName) {
    this.chatRoomId = chatRoomID;
    this.user_id = userID;
    this.user_name = userName;
  }

  Widget chatMessages(){
    return StreamBuilder<QuerySnapshot>(
      stream: chats,
      builder: (context, snapshot){
        return snapshot.hasData ?  ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index){
              return MessageTile(
                message: snapshot.data!.docs[index]["message"],
                sendByMe: user_id == snapshot.data!.docs[index]["sendBy"],
              );
            }) : Container(child: Text("Ban chua nhan gi "));
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

      database.addMessage(chatRoomId, chatMessageMap, messageEditingController.text, time, false);

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
      // appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          // decoration: const BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage("assets/images/bg2.png"),
          //     fit: BoxFit.cover,
          //   ),
          // ),
        child:Stack(
          children: <Widget>[
            chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              height: 80,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                color: Colors.grey,
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: messageEditingController,
                          style: TextStyle(color: Colors.black,fontSize: 16),
                          decoration: InputDecoration(
                              hintText: "Message ...",
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              border: InputBorder.none
                          ),
                        )
                    ),
                    SizedBox(width: 16,),
                    GestureDetector(
                      onTap: () {
                        addMessage();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                              borderRadius: BorderRadius.circular(40)
                          ),
                          padding: EdgeInsets.all(12),
                          child: Image.asset("assets/images/send.png", height: 25, width: 25,color: Colors.blue,)
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              height: 30,
              alignment: Alignment.bottomCenter,
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

  MessageTile({required this.message, required this.sendByMe});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: sendByMe ? 0 : 24,
          right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe
            ? EdgeInsets.only(left: 30)
            : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(
            top: 17, bottom: 17, left: 20, right: 20),
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
            gradient: LinearGradient(
              colors: sendByMe ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                  : [const Color(0x1A171414), const Color(0x1A393232)],
            )
        ),
        child: Text(
            message,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: sendByMe ? Colors.white : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w300)
        ),
      ),
    );
  }
}
