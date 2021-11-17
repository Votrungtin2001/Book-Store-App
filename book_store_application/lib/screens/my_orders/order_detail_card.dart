import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:book_store_application/MVP/Model/BookInCart.dart';
import 'package:book_store_application/firebase/providers/books_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderDetailCard extends StatefulWidget {
  late BookInCart book;

  OrderDetailCard(BookInCart book) {
    this.book = book;
  }

  @override
  _OrderDetailCardState createState() => _OrderDetailCardState(this.book);
}

class _OrderDetailCardState extends State<OrderDetailCard> {
  late BookInCart bookInCart;
  late Book book;
  final currencyformat = new NumberFormat("#,###,##0");

  _OrderDetailCardState(BookInCart BOOKINCART) {
    this.bookInCart = BOOKINCART;
  }

  @override
  Widget build(BuildContext context) {
    final booksProvider = Provider.of<BooksProvider>(context);
    for (int i = 0; i < booksProvider.books.length; i++) {
      if(booksProvider.books[i].getID() == bookInCart.getID()) book = booksProvider.books[i];

    }
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: AspectRatio(
              aspectRatio: 0.88,
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  //color: Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.network(book.getIMAGE_URL(), fit: BoxFit.fitHeight,),
              ),
            ),
          ),
          SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  bookInCart.getTITLE(),
                  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 2,
                ),
                SizedBox(height: 10,),
                Text(
                  bookInCart.getQUANTITY().toString(),
                  style: TextStyle(color: Colors.black38, fontSize: 14),
                ),
                SizedBox(height: 10,),
                Text(currencyformat.format(bookInCart.getTOTAL_PRICE()) + "đ"),
              ],
            ),
          )
        ],
      ) ,
    );
  }
}
