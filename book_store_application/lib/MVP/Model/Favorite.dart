import 'package:cloud_firestore/cloud_firestore.dart';

class Favorite {

  late String user_id;
  late List<dynamic> book_idList;

  Favorite(String ID, List<dynamic> LIST) {
    this.user_id = ID;
    this.book_idList = LIST;
  }

  String getUSER_ID() {return this.user_id;}
  void setUSER_ID(String ID) {this.user_id = ID;}

  int getBOOK_ID(int index) {return this.book_idList[index];}
  List<dynamic> getBOOK_ID_LIST() {return this.book_idList;}
  void setBOOK_ID_LIST(List<int> LIST) {this.book_idList = LIST;}


  Favorite.fromSnapshot(DocumentSnapshot snapshot) {
    user_id = snapshot.get('user_id');
    book_idList = snapshot.get('book_id');
  }

}