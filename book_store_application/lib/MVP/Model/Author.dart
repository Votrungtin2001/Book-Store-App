import 'package:cloud_firestore/cloud_firestore.dart';

class Author {

  late int id;
  late String name;

  Author(int ID, String NAME) {
    this.id = ID;
    this.name = NAME;
  }

  int getID() {return this.id;}
  void setID(int ID) {this.id = ID;}

  String getNAME() {return this.name;}
  void setNAME(String NAME) {this.name = NAME;}


  Author.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.get('id');
    name = snapshot.get('name');
  }

}