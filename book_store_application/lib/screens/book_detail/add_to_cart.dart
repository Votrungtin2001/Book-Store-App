import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:book_store_application/firebase/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../size_config.dart';

class AddToCart extends StatefulWidget {

  Book? book;
  AddToCart(Book? BOOK) {
    this.book = BOOK;
  }

  @override
  _AddToCartState createState() => _AddToCartState(this.book);
}
class _AddToCartState extends State<AddToCart> with TickerProviderStateMixin {

  int quantity = 0;
  Book? book;

  _AddToCartState(Book? book) {
    this.book = book;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    // Now this is fixed and only for demo
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              if(quantity == 0) {
                setState(() {
                  quantity = 0;
                });
              }
              else {
                setState(() {
                  quantity--;
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
                quantity++;
              });
            },
          ),
          Spacer(),
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              primary: Colors.white,
              backgroundColor: Colors.blue,
            ),
            onPressed: () {
              if(quantity > 0) {
                bool isUpdate = false;
                if (orderProvider.booksInCart.length > 0) {
                  for(int i = 0; i < orderProvider.booksInCart.length; i++) {
                    if (orderProvider.booksInCart[i].getID() == book!.getID()) {
                      isUpdate = true;
                    }
                  }
                  if(isUpdate) {
                    orderProvider.updateExtraQuantityAndTotalPrice(book!.getID(), quantity);
                    orderProvider.calculateTotalPrice();
                    Fluttertoast.showToast(msg: "Updated this book's quantity in you cart", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM);
                  }
                  else {
                    double total_price = quantity * book!.getPRICE();
                    orderProvider.addBookInCart(book!.getID(), book!.getTITLE(),
                        quantity, total_price);
                    orderProvider.calculateTotalPrice();
                    Fluttertoast.showToast(msg: "Added this book in you cart", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM);

                  }
                }
                else {
                  double total_price = quantity * book!.getPRICE();
                  orderProvider.addBookInCart(book!.getID(), book!.getTITLE(),
                      quantity, total_price);
                  orderProvider.calculateTotalPrice();
                  Fluttertoast.showToast(msg: "Added this book in you cart", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM);
                }
              }
              else Fluttertoast.showToast(msg: "Please choose quantity to add this book", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM);
              setState(() {
                quantity = 0;
              });

            },
            child: const Text(
              "Add To Cart",
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
