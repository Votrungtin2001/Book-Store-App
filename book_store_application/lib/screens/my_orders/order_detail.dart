import 'package:book_store_application/MVP/Model/BookInCart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'order_detail_card.dart';

class OrdersDetailScreen extends StatefulWidget {
  late List<BookInCart> books;

  OrdersDetailScreen(List<BookInCart> list) {
    this.books = list;
  }

  @override
  _OrdersDetailScreenState createState() => _OrdersDetailScreenState(this.books);
}

class _OrdersDetailScreenState extends State<OrdersDetailScreen> {

  late List<BookInCart> books;
  _OrdersDetailScreenState(List<BookInCart> list) {
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
    );
  }
}
