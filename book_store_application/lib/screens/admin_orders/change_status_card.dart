import 'package:book_store_application/firebase/providers/default_waitingOrders_provider.dart';
import 'package:book_store_application/screens/admin_profile/ProfileAdmin.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../admin_main_page.dart';

class ChangeStatusCard extends StatefulWidget {
  late String order_id;
  late String user_id;
  late int status;
  ChangeStatusCard(String order_id, String user_id, int status) {
    this.order_id = order_id;
    this.user_id = user_id;
    this.status = status;
  }

  @override
  _ChangeStatusCardState createState() => _ChangeStatusCardState(this.order_id, this.user_id, this.status);
}

class _ChangeStatusCardState extends State<ChangeStatusCard> {
  late String order_id;
  late String user_id;
  late int status;

  final DatabaseReference refOrders = FirebaseDatabase.instance.reference().child('Orders');
  
  _ChangeStatusCardState(String order_id, String user_id, int status) {
    this.order_id = order_id;
    this.user_id = user_id;
    this.status = status;
  }
  @override
  Widget build(BuildContext context) {
    final defaultWaitingOrdersProvider = Provider.of<DefaultWaitingOrderProvider>(context);
    final currencyformat = new NumberFormat("#,###,##0");
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: "Total:\n",
                    style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),
                    children: [
                      TextSpan(
                        text: currencyformat.format(defaultWaitingOrdersProvider.getTotalPrice(order_id)) + "đ",
                        style: TextStyle(fontSize: 21, color: Colors.red,fontWeight: FontWeight.bold),
                      ),
                    ],
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
