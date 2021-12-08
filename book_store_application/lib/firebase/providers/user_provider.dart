import 'package:book_store_application/MVP/Model/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier{
  User_Model user = new User_Model("", "", 0, "", "", "", "", "");
  String collection = "Users";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserProvider.initialize(){

  }

  UserProvider(){}

  Future<void> getUser(String User_ID) async =>
      _firestore.collection(collection).where('id', isEqualTo: User_ID).get().then((result) {
        for (DocumentSnapshot User in result.docs) {
          user = User_Model.fromSnapshot(User);
          notifyListeners();
        }
      });

  void setUser(User user) {
    user = user;
    notifyListeners();
  }

  void updatePhoto(String url) {
    user.setPhoto(url);
    notifyListeners();
  }

  Future<void> updateAddress(String User_ID, String Address) async {
    _firestore.collection(collection).doc(User_ID).update({'address': Address});
    user.setAddress(Address);
    notifyListeners();
  }

  Future<void> updatePhoneNumber(String User_ID, String PhoneNumber) async {
    _firestore.collection(collection).doc(User_ID).update({'phone': PhoneNumber});
    user.setPhone(PhoneNumber);
    notifyListeners();
  }

  Future<void> addChatRoom(chatRoom, chatRoomId) async {
    _firestore.collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  getChats(String chatRoomId) async{
    return _firestore
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }


  Future<void> addMessage(String chatRoomId, chatMessageData) async {
    _firestore.collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData).catchError((e){
      print(e.toString());
    });
  }

  getUserChats(String itIsMyName) async {
    return await _firestore
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }
}