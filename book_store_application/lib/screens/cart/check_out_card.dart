import 'package:book_store_application/MVP/Model/Order.dart';
import 'package:book_store_application/MVP/Model/User.dart';
import 'package:book_store_application/firebase/providers/order_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';


class CheckoutCard extends StatefulWidget {

  @override
  _CheckoutCardState createState() => _CheckoutCardState();

}
class _CheckoutCardState extends State<CheckoutCard> with TickerProviderStateMixin {

  final DatabaseReference refOrder = FirebaseDatabase.instance.reference().child('Orders');
  double total_price = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final currencyformat = new NumberFormat("#,###,##0");
    final user = Provider.of<User_MD?>(context);
    String user_id = "";
    if(user!.uid != null) user_id = user.uid.toString();

    return Container(
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
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F6F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SvgPicture.asset("assets/icons/receipt.svg"),
                ),
                Spacer(),
                Container(
                  width: 170,
                  //height: 20,
                  child: TextFormField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 1.0,horizontal: 5),
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(color: Colors.black)
                      ),
                      filled: true,
                      hintText: "Enter Voucher Code",
                      hintStyle: const TextStyle(color: Colors.black38),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 5),
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
                    onPressed: () async {
                      if(orderProvider.booksInCart.length > 0) {
                        Order order = new Order(0, user_id, "Vo trung tin", "123456789",
                            "phu tuc", orderProvider.booksInCart, orderProvider.total_price);
                        try {
                          FirebaseFirestore _firestore = FirebaseFirestore.instance;
                          DocumentReference docRef = _firestore.collection('Orders').doc();
                          String id = docRef.id;

                          await refOrder.child(order.getUSER_ID())
                              .child(id)
                              .set({'user_id': order.getUSER_ID(), 'name': order.getNAME(),
                            'phone': order.getPHONE(), 'address': order.getADDRESS(),
                           'total_price': order.getTOTAL_PRICE()});
                          int count = 0;
                          for(int i = 0; i < order.getBooksInCart().length; i++){
                            await refOrder.child(order.getUSER_ID())
                                .child(id)
                                .child('book_id')
                                .child(i.toString())
                                .update({'id': order.getBooksInCart()[i].getID(),
                                      'title': order.getBooksInCart()[i].getTITLE(),
                                      'quantity': order.getBooksInCart()[i].getQUANTITY(),
                                      'total_price': order.getBooksInCart()[i].getTOTAL_PRICE()});
                            count++;
                            if(count == order.getBooksInCart().length) {
                              orderProvider.throwBookSInCart();
                              Fluttertoast.showToast(
                                  msg: 'Add this order successfully.',
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM);
                            }
                          }
                        } catch (error) {
                          print(error.toString());
                        }

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
    );
  }

}