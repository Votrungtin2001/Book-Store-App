import 'package:book_store_application/MVP/Model/User.dart';
import 'package:book_store_application/firebase/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DatabaseMethods {

  searchByName(String searchField) {
    return FirebaseFirestore.instance
        .collection("Users")
        .where('name', isEqualTo: searchField)
        .get();
  }

  Future<void> addChatRoom(chatRoom,chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

   getName(){
    return FirebaseFirestore.instance
        .collection("Users")
        .orderBy('name')
        .get();
  }

  getChats(String chatRoomId) async{
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }

  Future<void> addMessage(chatRoomId, chatMessageData) async {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData)
        .catchError((e){
      print(e.toString());
    });
  }

  getUserChats(String itIsMyName) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .where('Users', arrayContains: itIsMyName)
        .snapshots();
  }

}