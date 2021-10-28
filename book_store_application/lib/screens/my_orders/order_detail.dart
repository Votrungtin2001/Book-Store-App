import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'order_detail_card.dart';

class OrdersDetailScreen extends StatefulWidget {
  const OrdersDetailScreen({Key? key}) : super(key: key);

  @override
  _OrdersDetailScreenState createState() => _OrdersDetailScreenState();
}

class _OrdersDetailScreenState extends State<OrdersDetailScreen> {
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
                itemCount: 2,
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
                    child: OrderDetailCard(),
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
