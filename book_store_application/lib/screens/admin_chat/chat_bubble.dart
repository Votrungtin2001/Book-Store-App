import 'package:flutter/material.dart';


import 'chat_detail_screen.dart';
import 'chat_message.dart';

class ChatBubble extends StatefulWidget {
  final ChatMessage chatMessage;
  final String img;
  ChatBubble({
    required this.chatMessage,
    required this.img,
  });
  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child: Align(
        alignment: (widget.chatMessage.type == MessageType.Receiver
            ? Alignment.topLeft
            : Alignment.topRight),
        child: Row(
          mainAxisAlignment: (widget.chatMessage.type == MessageType.Receiver
              ? MainAxisAlignment.start
              : MainAxisAlignment.end),
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.img),
              maxRadius:
              (widget.chatMessage.type == MessageType.Receiver ? 20 : 0),
            ),
            SizedBox(
              width: 8,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: (widget.chatMessage.type == MessageType.Receiver
                    ? Colors.white
                    : Colors.pink.shade100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: EdgeInsets.all(16),
              child: Text(
                widget.chatMessage.message,
                style: TextStyle(
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}