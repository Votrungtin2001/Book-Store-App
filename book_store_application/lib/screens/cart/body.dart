import 'package:book_store_application/MVP/Model/BookInCart.dart';
import 'package:book_store_application/MVP/Model/Order.dart';
import 'package:book_store_application/MVP/Model/User.dart';
import 'package:book_store_application/firebase/providers/order_provider.dart';
import 'package:book_store_application/screens/check_out/check_out_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'cart_card.dart';
import 'check_out_card.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  final DatabaseReference refOrder = FirebaseDatabase.instance.reference().child('Orders');
  final DatabaseReference refInventory = FirebaseDatabase.instance.reference().child('Inventory');
  double total_price = 0;
  int available = 0;
  List<BookInCart> booksInCart = [];

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final currencyformat = new NumberFormat("#,###,##0");
    final user = Provider.of<User_MD?>(context);
    String user_id = "";
    if(user!.uid != null) user_id = user.uid.toString();
    booksInCart = orderProvider.booksInCart;

    return Scaffold(
      body: Column(
        children: [
         // getAppBarUI(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                itemCount: booksInCart.length,
                itemBuilder: (context, index) {
                  final item = booksInCart[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Dismissible(
                      key: ObjectKey(item),
                      direction: DismissDirection.endToStart,
                      background: buildSwipeActionRight(),
                      onDismissed: (direction) {
                        setState(() {
                          int id = booksInCart[index].getID();
                          booksInCart.removeAt(index);
                          orderProvider.removeBooksInCart(id);
                          orderProvider.calculateTotalPrice();
                        });
                      },
                      child: CartCard(booksInCart[index]),
                    ),
                  );
                },
          )
    ))],
      ) ,
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15,),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30),),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -15),
              blurRadius: 20,
              color: Color(0xFFDADADA).withOpacity(0.20),
            )
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                      text: "Total:\n",
                      style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),
                      children: [
                        TextSpan(
                          text: currencyformat.format(orderProvider.total_price) + "đ",
                          style: TextStyle(fontSize: 21, color: Colors.red,fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 130,
                    height: 40,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        primary: Colors.white,
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        if(orderProvider.booksInCart.length > 0) {
                          setState(() {
                            booksInCart = [];
                          });
                          Navigator.push( context,
                            MaterialPageRoute(
                                builder: (context) => CheckOutScreen()
                            ),
                          );
                        }
                        else Fluttertoast.showToast(
                            msg: 'Please do not click check out when your cart is empty.',
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM);
                      },
                      child: Text(
                        "Check out",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget buildSwipeActionRight() => Container(
    height: 200,
    alignment: Alignment.centerRight,
    padding: EdgeInsets.symmetric(horizontal: 20),
    color: Colors.red,
    child: Icon(Icons.delete, color: Colors.white, size: 32),
  );
}
