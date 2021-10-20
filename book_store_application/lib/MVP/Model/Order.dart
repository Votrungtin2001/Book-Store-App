import 'package:book_store_application/MVP/Model/BookInCart.dart';

import 'BookInCart.dart';

class Order {
  late int id;
  late String user_id;
  late String name;
  late String phone;
  late String address;
  late List<BookInCart> booksInCart;
  late double total_price;

  Order(int ID, String USER_ID, String NAME, String PHONE, String ADDRESS,
    List<BookInCart> LIST, double TOTAL_PRICE) {
    this.id = ID;
    this.user_id = USER_ID;
    this.name = NAME;
    this.phone = PHONE;
    this.address = ADDRESS;
    this.booksInCart = LIST;
    this.total_price = TOTAL_PRICE;
  }

  int getID() {return this.id;}
  void setID(int ID) {this.id = ID;}

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
}