import 'package:book_store_application/firebase/providers/default_waitingOrders_provider.dart';
import 'package:book_store_application/screens/admin_profile/ProfileAdmin.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
                        text: "100000đ",
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
                    onPressed: ()  {
                      if(status == 0) {
                        refOrders.child(user_id).child(order_id).update(
                            {'status': 1});
                        defaultWaitingOrdersProvider.updateStatus(order_id, 1);
                      }
                      else if(status == 1) {
                        refOrders.child(user_id).child(order_id).update(
                            {'status': 2});
                        defaultWaitingOrdersProvider.updateStatus(order_id, 2);
                      }
                      else if(status == 2) {
                        refOrders.child(user_id).child(order_id).update(
                            {'status': 3});
                        defaultWaitingOrdersProvider.updateStatus(order_id, 3);
                      }

                      Navigator.pop(context);

                      Fluttertoast.showToast(msg: "Updated order's status successully", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
                      
                    },
                    child: Text(
                      "Next",
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
