import 'package:flutter/material.dart';

import 'order_detail.dart';

class OrderCard extends StatefulWidget {
  const OrderCard({Key? key}) : super(key: key);

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){
          Navigator.push( context,
            MaterialPageRoute(
              builder: (context) => OrdersDetailScreen(),
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
                Text("Minh Thi",style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Text("Order Time:",style: TextStyle(fontWeight: FontWeight.w600)),
                    SizedBox(width: 10,),
                    Text("20/11/2021")
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
                          Text("#2736352"),
                        ],
                      ),
                      VerticalDivider(thickness: 1,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Order Amount",style: TextStyle(fontWeight: FontWeight.w600)),
                          SizedBox(height: 8,),
                          Text("1000000đ"),
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
                    Text("Do Tin doan duoc"),
                  ],
                ),
                Divider(thickness: 2,),
                Row(
                  children: [
                    Icon(Icons.phone),
                    SizedBox(width: 10,),
                    Text("0178910JQK"),
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
