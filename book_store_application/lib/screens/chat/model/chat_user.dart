// import 'package:cloud_firestore/cloud_firestore.dart';
//
//
// class DatabaseMethods {
//   Future<bool> addChatRoom(chatRoom, chatRoomId) {
//     Firestore.instance
//         .collection("chatRoom")
//         .document(chatRoomId)
//         .setData(chatRoom)
//         .catchError((e) {
//       print(e);
//     });
//   }
//
//   getChats(String chatRoomId) async{
//     return Firestore.instance
//         .collection("chatRoom")
//         .document(chatRoomId)
//         .collection("chats")
//         .orderBy('time')
//         .snapshots();
//   }
//
//
//   Future<void> addMessage(String chatRoomId, chatMessageData) async {
//
//     Firestore.instance.collection("chatRoom")
//         .document(chatRoomId)
//         .collection("chats")
//         .add(chatMessageData).catchError((e){
//       print(e.toString());
//     });
//   }
//
//   getUserChats(String itIsMyName) async {
//     return await Firestore.instance
//         .collection("chatRoom")
//         .where('users', arrayContains: itIsMyName)
//         .snapshots();
//   }
// }