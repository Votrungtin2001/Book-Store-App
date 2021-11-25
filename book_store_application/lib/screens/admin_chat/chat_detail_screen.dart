import 'package:flutter/material.dart';


import 'chat_bubble.dart';
import 'chat_message.dart';

enum MessageType {
  Sender,
  Receiver,
}

class ChatDetailScreen extends StatefulWidget {
  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  List<ChatMessage> chatMessage = [
    ChatMessage(message: "Hello everyone", type: MessageType.Sender),
    ChatMessage(message: "Hi.", type: MessageType.Receiver),
    ChatMessage(message: "Hello", type: MessageType.Receiver),
    ChatMessage(message: "Bello", type: MessageType.Receiver),
    ChatMessage(
        message: "The cafe is at 596st right?", type: MessageType.Receiver),
    ChatMessage(message: "Yub :3", type: MessageType.Sender),
    ChatMessage(
        message: "See you guys there at 8a.m", type: MessageType.Receiver),
    ChatMessage(
        message: "I'm going to get there too", type: MessageType.Sender),
    ChatMessage(message: "Wait for me!!!", type: MessageType.Receiver),
    ChatMessage(message: "I'm on the go too :D", type: MessageType.Receiver),
    ChatMessage(
        message: "I've got a table for 4 and waiting for you guys.",
        type: MessageType.Sender),
    ChatMessage(
        message: "Just a little bit more :>", type: MessageType.Receiver),
  ];
  List<String> images = [
    "",
    "https://i.pinimg.com/originals/72/cd/96/72cd969f8e21be3476277d12d44c791c.png",
    "https://img2.pngio.com/bearded-man-hipster-male-avatar-male-person-young-man-icon-male-person-icon-png-512_512.png",
    "https://avatarfiles.alphacoders.com/791/79102.png",
    "https://i.pinimg.com/originals/72/cd/96/72cd969f8e21be3476277d12d44c791c.png",
    "",
    "https://i.pinimg.com/originals/72/cd/96/72cd969f8e21be3476277d12d44c791c.png",
    "",
    "https://img2.pngio.com/bearded-man-hipster-male-avatar-male-person-young-man-icon-male-person-icon-png-512_512.png",
    "https://img2.pngio.com/bearded-man-hipster-male-avatar-male-person-young-man-icon-male-person-icon-png-512_512.png",
    "",
    "https://img2.pngio.com/bearded-man-hipster-male-avatar-male-person-young-man-icon-male-person-icon-png-512_512.png",
  ];
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
                  backgroundImage: NetworkImage(
                      "https://vietblend.vn/wp-content/uploads/2016/09/0a5b4a843a59dc078548.jpg"),
                  maxRadius: 25,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Cafe event",
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        "Online",
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w400,
                            color: Colors.green,
                            fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.more_vert,
                  color: Colors.grey.shade700,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg1.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: ListView.builder(
                  itemCount: chatMessage.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ChatBubble(
                      img: images[index],
                      chatMessage: chatMessage[index],
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: EdgeInsets.only(left: 16, bottom: 10),
                  height: 80,
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 21,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: TextField(
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
                  padding: EdgeInsets.only(right: 30, bottom: 50),
                  child: FloatingActionButton(
                    onPressed: () {},
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
      ),
    );
  }
}