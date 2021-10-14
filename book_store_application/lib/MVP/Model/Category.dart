import 'package:cloud_firestore/cloud_firestore.dart';

class Category {

  late int id;
  late String name;
  late String image_url;

  Category(int ID, String NAME, String IMAGE_URL) {
    this.id = ID;
    this.name = NAME;
    this.image_url = IMAGE_URL;
  }

  int getID() {return this.id;}
  void setID(int ID) {this.id = ID;}

  String getNAME() {return this.name;}
  void setNAME(String NAME) {this.name = NAME;}

  String getIMAGE_URL() {return this.image_url;}
  void setIMAGE_URL(String IMAGE_URL) {this.image_url = IMAGE_URL;}

  Category.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.get('id');
    name = snapshot.get('name');
    image_url = snapshot.get('image_url');
  }

}