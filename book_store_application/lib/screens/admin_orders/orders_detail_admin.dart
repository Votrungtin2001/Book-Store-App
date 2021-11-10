import 'package:book_store_application/MVP/Model/BookInCart.dart';
import 'package:book_store_application/screens/admin_orders/change_status_card.dart';
import 'package:book_store_application/screens/my_orders/order_detail_card.dart';
import 'package:flutter/material.dart';

class OrdersDetailAdminScreen extends StatefulWidget {
  late List<BookInCart> books;

  OrdersDetailAdminScreen(List<BookInCart> list) {
    this.books = list;
  }


  @override
  _OrdersDetailAdminScreenState createState() => _OrdersDetailAdminScreenState(this.books);
}

class _OrdersDetailAdminScreenState extends State<OrdersDetailAdminScreen> {
  late List<BookInCart> books;
  _OrdersDetailAdminScreenState(List<BookInCart> list) {
    this.books = list;
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
      bottomNavigationBar: ChangeStatusCard(),
    );
  }
}
