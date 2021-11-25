import 'package:flutter/material.dart';

import 'chat_user.dart';
import 'chat_user_list.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<ChatUser> chatUsers = [
    ChatUser(
        name: "Cafe event",
        newtext: "Awesome Setup",
        image:
        "https://vietblend.vn/wp-content/uploads/2016/09/0a5b4a843a59dc078548.jpg",
        time: "Now"),
    ChatUser(
        name: "Dinner",
        newtext: "That's Great",
        image:
        "https://i.pinimg.com/originals/8b/9c/b0/8b9cb0ee3674fd67b2a146e030d017f5.jpg",
        time: "Yesterday"),
    ChatUser(
        name: "Photography",
        newtext: "Hey where are you?",
        image:
        "https://i.pinimg.com/originals/17/63/a8/1763a8f71feb72a34765f8d020d84ff1.jpg",
        time: "31 Mar"),
    ChatUser(
        name: "Breakfast",
        newtext: "Busy! Call me in 20 mins",
        image:
        "https://i.pinimg.com/564x/d3/e4/ac/d3e4ac65966f4c8ef20c212f51749847.jpg",
        time: "28 Mar"),
    ChatUser(
        name: "Games",
        newtext: "Thankyou, It's awesome",
        image:
        "https://i.pinimg.com/564x/80/2b/03/802b035cdcbcf867a57e0db239077a72.jpg",
        time: "23 Mar"),
    ChatUser(
        name: "Running",
        newtext: "will update you in evening",
        image:
        "https://i.pinimg.com/564x/a4/e3/bf/a4e3bf7dc89537ba84eea01609727522.jpg",
        time: "17 Mar"),
    ChatUser(
        name: "Badminton",
        newtext: "Can you please share the racket?",
        image:
        "https://i.pinimg.com/564x/a1/eb/e5/a1ebe544eb4882f6fb68cf67e03c5e6f.jpg",
        time: "24 Feb"),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg2.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 85),
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
                  Padding(
                    padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search...",
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey.shade400,
                          size: 20,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: EdgeInsets.all(8),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide:
                            BorderSide(color: Colors.grey.shade100)),
                      ),
                    ),
                  ),
                  ListView.builder(
                    itemCount: chatUsers.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 16),
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ChatUsersList(
                        name: chatUsers[index].name,
                        newtext: chatUsers[index].newtext,
                        image: chatUsers[index].image,
                        time: chatUsers[index].time,
                        isMessageRead:
                        (index == 0 || index == 3) ? true : false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
