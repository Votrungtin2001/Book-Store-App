import 'package:cloud_firestore/cloud_firestore.dart';

class User_Model {
  String id = "";
  String name = "";
  late int role = 0;
  late String address= "";
  late String phone= "";
  late String dob= "";
  late String gender= "";
  late String photo = "";

  User_Model(String ID, String Name, int Role, String Address, String Phone, String Dob, String Gender, String Photo) {
    this.id = ID;
    this.name = Name;
    this.role = Role;
    this.address = Address;
    this.phone = Phone;
    this.dob = Dob;
    this.gender = Gender;
    this.photo = Photo;
  }

  String getID() {return this.id;}
  void setID(String ID) {this.id = ID;}

  String getName() {return this.name;}
  void setName(String Name) {this.name = Name;}

  int getRole() {return this.role;}
  void setRole(int Role) {this.role = Role;}

  String getPhoto() {return this.photo;}
  void setPhoto(String Photo) {this.photo = Photo;}


  String getAddress() {return this.address;}
  void setAddress(String Address) {this.address = Address;}

  String getPhone() {return this.phone;}
  void setPhone(String Phone) {this.phone = Phone;}

  String getDob() {return this.dob;}
  void setDob(String Dob) {this.dob = Dob;}

  String getGender() {return this.gender;}
  void setGender(String Gender) {this.gender = Gender;}

  User_Model.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.get('id');
    address = snapshot.get('address');
    dob = snapshot.get('dob');
    gender = snapshot.get('gender');
    name = snapshot.get('name');
    phone = snapshot.get('phone');
    photo = snapshot.get('photo');
    role = snapshot.get('role');
  }
}

class User_MD {

  final String? uid;

  User_MD({this.uid});

}