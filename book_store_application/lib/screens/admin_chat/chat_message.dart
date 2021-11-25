import 'package:flutter/material.dart';


import 'chat_detail_screen.dart';

class ChatMessage {
  String message;
  MessageType type;
  ChatMessage({required this.message, required this.type});
}