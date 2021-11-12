import 'package:book_store_application/MVP/Model/BookInCart.dart';
import 'package:book_store_application/screens/admin_orders/change_status_card.dart';
import 'package:book_store_application/screens/my_orders/order_detail_card.dart';
import 'package:flutter/material.dart';

class OrdersDetailAdminScreen extends StatefulWidget {
  late String order_id;
  late String user_id;
  late List<BookInCart> books;
  late int status;

  OrdersDetailAdminScreen(List<BookInCart> list, String order_id, String user_id, int status) {
    this.books = list;
    this.order_id = order_id;
    this.user_id = user_id;
    this.status = status;
  }


  @override
  _OrdersDetailAdminScreenState createState() => _OrdersDetailAdminScreenState(this.books, this.order_id, this.user_id, this.status);
}

class _OrdersDetailAdminScreenState extends State<OrdersDetailAdminScreen> {
  late List<BookInCart> books;
  late String order_id;
  late String user_id;
  late int status;
  _OrdersDetailAdminScreenState(List<BookInCart> list, String order_id, String user_id, int status) {
    this.books = list;
    this.order_id = order_id;
    this.user_id = user_id;
    this.status = status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // getAppBarUI(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.16),
                          offset: Offset(0, 5),
                          blurRadius: 10.0,
                        )
                      ],
                    ),
                    child: OrderDetailCard(books[index]),
                  ),
                ),
              ),
            ),
          )
        ],
      ) ,
      bottomNavigationBar: ChangeStatusCard(order_id, user_id, status),
    );
  }
}
