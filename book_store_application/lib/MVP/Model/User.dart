class User_Model {
  String id = "";
  String name = "";
  late int role = 0;
  late String address= "";
  late String phone= "";
  late String dob= "";
  late String gender= "";
  late int photo = 0;

  User_Model(String ID, String Name, int Role, String Address, String Phone, String Dob, String Gender, int Photo) {
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

  int getPhoto() {return this.photo;}
  void setPhoto(int Photo) {this.photo = Photo;}


  String getAddress() {return this.address;}
  void setAddress(String Address) {this.address = Address;}

  String getPhone() {return this.phone;}
  void setPhone(String Phone) {this.phone = Phone;}

  String getDob() {return this.dob;}
  void setDob(String Dob) {this.dob = Dob;}

  String getGender() {return this.gender;}
  void setGender(String Gender) {this.gender = Gender;}
}

class User_MD {

  final String? uid;

  User_MD({this.uid});

}