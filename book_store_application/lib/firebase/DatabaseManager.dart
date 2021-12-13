import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:book_store_application/MVP/Model/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseManager {
  final List<int> book_id = [];
  final CollectionReference Users = FirebaseFirestore.instance.collection('Users');

  final DatabaseReference refFavorite = FirebaseDatabase.instance.reference().child('Favorites');


  Future<void> createUserData(User_Model user_model) async {
    return await Users
        .doc(user_model.id)
        .set({'id': user_model.id, 'name': user_model.name, 'role': user_model.role, 'address': user_model.address,
                'phone': user_model.phone, 'dob': user_model.dob, 'gender': user_model.gender, 'photo': "https://firebasestorage.googleapis.com/v0/b/book-store-app-3d8a6.appspot.com/o/none_avatar.jpg?alt=media&token=41662994-4635-45ef-ae01-0d929fbd8f91"}
                );
  }



  Future<void> createFavorites(User_Model user_model) async {
    return await refFavorite
        .child(user_model.id)
        .set({'user_id': user_model.id, 'book_id': book_id});
  }

  searchByName(String searchField) {
    return FirebaseFirestore.instance
        .collection("Users")
        .where('name', isEqualTo: searchField)
        .get();
  }

  Future<void> addChatRoom(chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .set({'chatRoomID': chatRoomId,
          'latestMessage': "",
          'latestMessageTime': DateTime.now().millisecondsSinceEpoch,
          'isSeenByAdmin': false})
        .catchError((e) {
      print(e);
    });
  }

  Future<void> addMessage(chatRoomId, chatMessageData) async {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("Chat")
        .add(chatMessageData)
        .catchError((e){
      print(e.toString());
    });
  }

  getChats(String chatRoomId) async{
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("Chat")
        .orderBy('time')
        .snapshots();
  }




  /*Future updateUserList(String name, String gender, int score, String uid) async {
    return await profileList.document(uid).updateData({
      'name': name, 'gender': gender, 'score': score
    });
  }

  Future getUsersList() async {
    List itemsList = [];

    try {
      await profileList.getDocuments().then((querySnapshot) {
        querySnapshot.documents.forEach((element) {
          itemsList.add(element.data);
        });
      });
      return itemsList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }*/
}