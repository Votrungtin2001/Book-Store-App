import 'package:book_store_application/MVP/Model/BookInCart.dart';
import 'package:book_store_application/MVP/Model/Order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class OrderProvider with ChangeNotifier{

  List<BookInCart> booksInCart = [];
  List<BookInCart> newBooksInCart = [];
  double total_price = 0;

  List<Order> orders = [];
  List<Order> ordersByStatus = [];
  final DatabaseReference refOrders = FirebaseDatabase.instance.reference().child('Orders');

  OrderProvider.initialize(){

  }

  List<BookInCart> getBooksInCart() {
    return booksInCart;
  }

  void addBookInCart(int ID, String TITLE, int QUANTITY, double TOTAL_PRICE) {
    BookInCart bookInCart = new BookInCart(ID, TITLE, QUANTITY, TOTAL_PRICE);
    booksInCart.add(bookInCart);
    notifyListeners();
  }

  void removeBooksInCart(int ID) {
    for (int i = 0; i < booksInCart.length; i++) {
      if(booksInCart[i].getID() == ID) {
        booksInCart.removeAt(i);
      }
    }
    notifyListeners();
  }

  void updateExtraQuantityAndTotalPrice(int ID, int QUANTITY) {
    for (int i = 0; i < booksInCart.length; i++) {
      if(booksInCart[i].getID() == ID) {
        int old_quantity = booksInCart[i].getQUANTITY();
        double price = booksInCart[i].getTOTAL_PRICE() / old_quantity;
        int new_quantity = old_quantity + QUANTITY;
        double total_price = price * new_quantity;
        booksInCart[i].setQUANTITY(new_quantity);
        booksInCart[i].setTOTAL_PRICE(total_price);
      }
    }
    notifyListeners();
  }

  void updateQuantityAndTotalPrice(int ID, int QUANTITY) {
    for (int i = 0; i < booksInCart.length; i++) {
      if(booksInCart[i].getID() == ID) {
        int old_quantity = booksInCart[i].getQUANTITY();
        double price = booksInCart[i].getTOTAL_PRICE() / old_quantity;
        int new_quantity = QUANTITY;
        double total_price = price * new_quantity;
        booksInCart[i].setQUANTITY(new_quantity);
        booksInCart[i].setTOTAL_PRICE(total_price);
      }
    }
    notifyListeners();
  }

  void calculateTotalPrice() {
    double temp = 0;
    for (int i = 0; i < booksInCart.length; i++) {
      temp+= booksInCart[i].getTOTAL_PRICE();
    }
    total_price = temp;
    notifyListeners();
  }

  void throwBookSInCart() {
    booksInCart = newBooksInCart;
    total_price = 0;
    notifyListeners();
  }

  Future<void> getOrders(String User_ID) async {
    orders = [];
    await refOrders.child(User_ID).once().then((DataSnapshot snapshot1){
      Map<dynamic, dynamic> values1 = snapshot1.value;
      values1.forEach((key,values1) async {
        List<BookInCart> books = [];
        String order_id = values1['order_id'].toString();
        String address = values1['address'].toString();
        String date = values1['date'].toString();
        String name = values1['name'].toString();
        String phone = values1['phone'].toString();
        int status = int.parse(values1['status'].toString());
        double total_price = double.parse(values1['total_price'].toString());
        String user_id = values1['user_id'].toString();
        await refOrders.child(User_ID).child(order_id).child('book_id').once().then((DataSnapshot snapshot2) {
          List<dynamic> result = snapshot2.value;
          result.forEach((value) {
            int book_id = int.parse(value['id'].toString());
            int quantity = int.parse(value['quantity'].toString());
            String title = value['title'].toString();
            double total = double.parse(value['total_price'].toString());
            BookInCart book = new BookInCart(book_id, title, quantity, total);
            books.add(book);
          });
        });
        Order order = new Order(order_id, user_id, name, phone, address, books, total_price, status, date);
        orders.add(order);
      });
    });
    notifyListeners();
  }

  void getOrdersByStatus(int Status) {
    List<Order> list = [];
    if(Status == 0) {
      for (int i = 0; i < orders.length; i++) {
        if(orders[i].getSTATUS() == 0) list.add(orders[i]);
      }
    }
    else  if(Status == 1) {
      for (int i = 0; i < orders.length; i++) {
        if(orders[i].getSTATUS() == 1) list.add(orders[i]);
      }
    }
    else  if(Status == 2) {
      for (int i = 0; i < orders.length; i++) {
        if(orders[i].getSTATUS() == 2) list.add(orders[i]);
      }
    }
    else if(Status == 3) {
      for (int i = 0; i < orders.length; i++) {
        if(orders[i].getSTATUS() == 3) list.add(orders[i]);
      }
    }
    ordersByStatus = list;
  }

}