import 'package:flutter/material.dart';

class ChatUser {
  String name;
  String newtext;
  String image;
  String time;
  ChatUser(
      {required this.name,
        required this.newtext,
        required this.image,
        required this.time});
}