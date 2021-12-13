import 'package:book_store_application/MVP/Model/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier{
  User_Model user = new User_Model("", "", 0, "", "", "", "", "");
  String collection = "Users";
  User_Model user_temp = new User_Model("", "", 0, "", "", "", "", "");
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserProvider.initialize(){}

  UserProvider(){}

  Future<void> getUser(String User_ID) async =>
      _firestore.collection(collection).where('id', isEqualTo: User_ID).get().then((result) {
        for (DocumentSnapshot User in result.docs) {
          user = User_Model.fromSnapshot(User);
          notifyListeners();
        }
      });

  Future<void> getUserForChatRoom(String User_ID) async =>
      _firestore.collection(collection).where('id', isEqualTo: User_ID).get().then((result) {
        for (DocumentSnapshot User in result.docs) {
          user_temp = User_Model.fromSnapshot(User);
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

}