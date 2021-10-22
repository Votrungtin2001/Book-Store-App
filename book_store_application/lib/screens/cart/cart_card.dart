import 'package:book_store_application/MVP/Model/Author.dart';
import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:book_store_application/MVP/Model/BookInCart.dart';
import 'package:book_store_application/firebase/providers/author_provider.dart';
import 'package:book_store_application/firebase/providers/books_provider.dart';
import 'package:book_store_application/firebase/providers/order_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';


class CartCard extends StatefulWidget {
  late BookInCart bookInCart;

  CartCard(BookInCart BOOKINCART) {
    this.bookInCart = BOOKINCART;
  }

  @override
  _CartCardState createState() => _CartCardState(this.bookInCart);
}
class _CartCardState extends State<CartCard> with TickerProviderStateMixin {

  int quantity = 0;
  late BookInCart bookInCart;
  late Book book;
  List<Author> authors = [];

  final DatabaseReference refInventory = FirebaseDatabase.instance.reference().child('Inventory');
  int available = 0;
  
  _CartCardState(BookInCart BOOKINCART) {
    this.bookInCart = BOOKINCART;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final booksProvider = Provider.of<BooksProvider>(context);
    final authorProvider = Provider.of<AuthorProvider>(context);
    final currencyformat = new NumberFormat("#,###,##0");
    authors = authorProvider.authors;

    for (int i = 0; i < booksProvider.books.length; i++) {
      if(booksProvider.books[i].getID() == bookInCart.getID()) book = booksProvider.books[i];
    }
    if (quantity == 0) quantity = bookInCart.getQUANTITY();

    getAvailable(book.getID());

    return Container(
      width: MediaQuery.of(context).size.width,
      child:Row(
        children: [
          SizedBox(
            width: 100,
            child: AspectRatio(
              aspectRatio: 0.88,
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F6F9),
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
                  book.getTITLE(),
                  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 2,
                ),
                Text(
                  getAuthorName(book.getAUTHOR_ID()),
                  style: TextStyle(color: Colors.black12, fontSize: 14),
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Text(currencyformat.format(book.getPRICE()) + "đ"),
                    SizedBox(width: 95,),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            if(quantity == 1) {
                              Fluttertoast.showToast(
                                  msg: 'Reached the minimum quantity',
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM);
                            }
                            else {
                              setState(() {
                                quantity--;
                                orderProvider.updateQuantityAndTotalPrice(bookInCart.getID(), quantity);
                                orderProvider.calculateTotalPrice();
                              });
                            }
                          },
                        ),
                        const SizedBox(width: 10),
                        Text(quantity.toString()),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              if(quantity < available) {
                                quantity++;
                                orderProvider.updateQuantityAndTotalPrice(bookInCart.getID(), quantity);
                                orderProvider.calculateTotalPrice();
                              }
                              else Fluttertoast.showToast(msg: "This book is not enough quantity to provide", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM);
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )

        ],
      ) ,
    );

  }

  String getAuthorName(int author_id) {
    for(int i = 0; i < authors.length; i++) {
      if(authors[i].getID() == author_id) {
        return authors[i].getNAME();
      }
    }
    return "";
  }

  Future<void> getAvailable(int book_id) async {
    await refInventory.child(book_id.toString())
        .once().then((DataSnapshot dataSnapshot) {
      if(dataSnapshot.exists) {
        setState(() {
          available = dataSnapshot.value['quantity'];
        });
      }
    });
  }

}