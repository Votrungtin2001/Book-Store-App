import 'package:book_store_application/MVP/Model/Order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'order_detail.dart';

class OrderCard extends StatefulWidget {
  late Order order;

  OrderCard(Order ORDER) {
    this.order = ORDER;
  }

  @override
  _OrderCardState createState() => _OrderCardState(this.order);
}

class _OrderCardState extends State<OrderCard> {

  late Order order;
  final currencyformat = new NumberFormat("#,###,##0");

  _OrderCardState(Order ORDER) {
    this.order = ORDER;
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){
          Navigator.push( context,
            MaterialPageRoute(
              builder: (context) => OrdersDetailScreen(order.getBooksInCart()),
            ),
          );
        },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.getNAME(),style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Text("Order Time:",style: TextStyle(fontWeight: FontWeight.w600)),
                    SizedBox(width: 10,),
                    Text(order.getDATE())
                  ],
                ),
                Divider(thickness: 2,),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Order Id",style: TextStyle(fontWeight: FontWeight.w600)),
                          SizedBox(height: 8,),
                          Text(order.getID()),
                        ],
                      ),
                      VerticalDivider(thickness: 1,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Order Amount",style: TextStyle(fontWeight: FontWeight.w600)),
                          SizedBox(height: 8,),
                          Text(currencyformat.format(order.getTOTAL_PRICE()) + "??"),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(thickness: 2,),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined),
                    SizedBox(width: 10,),
                    Text(order.getADDRESS()),
                  ],
                ),
                Divider(thickness: 2,),
                Row(
                  children: [
                    Icon(Icons.phone),
                    SizedBox(width: 10,),
                    Text(order.getPHONE()),
                  ],
                ),
              ],
            ),
          ),

        )
    )
    );
  }
}
