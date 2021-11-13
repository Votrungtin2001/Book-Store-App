import 'package:book_store_application/MVP/Model/BookInCart.dart';
import 'package:book_store_application/MVP/Model/Order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class DefaultWaitingOrderProvider with ChangeNotifier{

  List<Order> orders = [];
  final DatabaseReference refOrders = FirebaseDatabase.instance.reference().child('Orders');

  DefaultWaitingOrderProvider.initialize(){
    getDefaultWaitingOrders();
  }

  void removeOrder(String ID) {
    for (int i = 0; i < orders.length; i++) {
      if(orders[i].getID() == ID) orders.removeAt(i);
    }
    notifyListeners();
  }

  void updateStatus(String ID, int Status) {
    for (int i = 0; i < orders.length; i++) {
      if(orders[i].getID() == ID) orders[i].setSTATUS(Status);
    }
    notifyListeners();
  }

  void addOrder(Order order) {
    orders.add(order);
    notifyListeners();
  }

  List<Order> getWaitingOrders() {
    List<Order> list = [];
    for(int i = 0; i < orders.length; i++) {
      if(orders[i].getSTATUS() == 0) list.add(orders[i]);
    }
    return list;
  }

  List<Order> getWaitingOrdersOfUser(String user_id) {
    List<Order> list = [];
    for(int i = 0; i < orders.length; i++) {
      if(orders[i].getSTATUS() == 0 && orders[i].getUSER_ID() == user_id) list.add(orders[i]);
    }
    return list;
  }

  List<Order> getPreparingOrdersOfUser(String user_id) {
    List<Order> list = [];
    for(int i = 0; i < orders.length; i++) {
      if(orders[i].getSTATUS() == 1 && orders[i].getUSER_ID() == user_id) list.add(orders[i]);
    }
    return list;
  }

  List<Order> getDeliveringOrdersOfUser(String user_id) {
    List<Order> list = [];
    for(int i = 0; i < orders.length; i++) {
      if(orders[i].getSTATUS() == 2 && orders[i].getUSER_ID() == user_id) list.add(orders[i]);
    }
    return list;
  }

  List<Order> getReceivedOrdersOfUser(String user_id) {
    List<Order> list = [];
    for(int i = 0; i < orders.length; i++) {
      if(orders[i].getSTATUS() == 3 && orders[i].getUSER_ID() == user_id) list.add(orders[i]);
    }
    return list;
  }

  List<Order> getPreparingOrders() {
    List<Order> list = [];
    for(int i = 0; i < orders.length; i++) {
      if(orders[i].getSTATUS() == 1) list.add(orders[i]);
    }
    return list;
  }

  List<Order> getDeliveringOrders() {
    List<Order> list = [];
    for(int i = 0; i < orders.length; i++) {
      if(orders[i].getSTATUS() == 2) list.add(orders[i]);
    }
    return list;
  }

  List<Order> getReceivedOrders() {
    List<Order> list = [];
    for(int i = 0; i < orders.length; i++) {
      if(orders[i].getSTATUS() == 3) list.add(orders[i]);
    }
    return list;
  }

  double getTotalPrice(String order_id) {
    for (int i = 0; i < orders.length; i++) {
      if(orders[i].getID() == order_id) return orders[i].getTOTAL_PRICE();
    }
    return 0;
  }

  Future<void> getDefaultWaitingOrders() async {
    orders = [];
    await refOrders.limitToLast(10).once().then((DataSnapshot snapshot1) {
      Map<dynamic, dynamic> values1 = snapshot1.value;
      values1.forEach((key, values1) async {
        String user_id = key;
        refOrders.child(user_id).orderByChild('created').limitToLast(10).once().then((DataSnapshot snapshot2) {
          Map<dynamic, dynamic> values2 = snapshot2.value;
          values2.forEach((key, values2) async {
            List<BookInCart> books = [];
            String order_id = values2['order_id'].toString();
            String address = values2['address'].toString();
            String date = values2['date'].toString();
            String name = values2['name'].toString();
            String phone = values2['phone'].toString();
            int status = int.parse(values2['status'].toString());
            double total_price = double.parse(
                values2['total_price'].toString());
            String user_ID = values2['user_id'].toString();

              refOrders.child(user_ID).child(order_id).child('book_id')
                  .once()
                  .then((DataSnapshot snapshot3) {
                List<dynamic> result = snapshot3.value;
                result.forEach((value) {
                  int book_id = int.parse(value['id'].toString());
                  int quantity = int.parse(value['quantity'].toString());
                  String title = value['title'].toString();
                  double total = double.parse(value['total_price'].toString());
                  BookInCart book = new BookInCart(
                      book_id, title, quantity, total);
                  books.add(book);
                });
              });
              Order order = new Order(order_id, user_ID, name, phone, address, books, total_price, status, date);
              orders.add(order);
            }
          );
        });
      });
    });
    notifyListeners();
  }

}