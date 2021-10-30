import 'package:book_store_application/MVP/Model/BookInCart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'BookInCart.dart';

class Order {
  late String id;
  late String user_id;
  late String name;
  late String phone;
  late String address;
  late List<BookInCart> booksInCart;
  late double total_price;
  late int status;
  late String date;
  List<BookInCart> emptyList = [];


  Order(String ID, String USER_ID, String NAME, String PHONE, String ADDRESS,
    List<BookInCart> LIST, double TOTAL_PRICE, int STATUS, String DATE) {
    this.id = ID;
    this.user_id = USER_ID;
    this.name = NAME;
    this.phone = PHONE;
    this.address = ADDRESS;
    this.booksInCart = LIST;
    this.total_price = TOTAL_PRICE;
    this.status = STATUS;
    this.date = DATE;
  }

  String getID() {return this.id;}
  void setID(String ID) {this.id = ID;}

  int getSTATUS() {return this.status;}
  void setSTATUS(int STATUS) {this.status = STATUS;}

  String getDATE() {return this.date;}
  void setDATE(String DATE) {this.date = DATE;}

  String getUSER_ID() {return this.user_id;}
  void setUSER_ID(String USER_ID) {this.user_id = USER_ID;}

  String getNAME() {return this.name;}
  void setNAME(String NAME) {this.name = NAME;}

  String getPHONE() {return this.phone;}
  void setNPHONE(String PHONE) {this.phone = PHONE;}

  String getADDRESS() {return this.address;}
  void setADDRESS(String ADDRESS) {this.address = ADDRESS;}

  List<BookInCart> getBooksInCart() {return this.booksInCart;}
  void setBooksInCart(List<BookInCart> LIST) {this.booksInCart = LIST;}

  double getTOTAL_PRICE() {return this.total_price;}
  void setTOTAL_PRICE(double TOTAL_PRICE) {this.total_price = TOTAL_PRICE;}

  Order.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.get('order_id');
    address = snapshot.get('address');
    date = snapshot.get('date');
    name = snapshot.get('name');
    booksInCart = (snapshot.get('book_id') as List<dynamic>).isEmpty ? emptyList : snapshot.get('book_id');
    phone = snapshot.get('category_id');
    status = snapshot.get('status');
    total_price = snapshot.get('total_price');
    user_id = snapshot.get('user_id');
  }
}