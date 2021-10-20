import 'package:cloud_firestore/cloud_firestore.dart';

class Publisher {

  late int id;
  late String name;

  Publiser(int ID, String NAME) {
    this.id = ID;
    this.name = NAME;
  }

  int getID() {return this.id;}
  void setID(int ID) {this.id = ID;}

  String getNAME() {return this.name;}
  void setNAME(String NAME) {this.name = NAME;}


  Publisher.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.get('id');
    name = snapshot.get('name');
  }

}