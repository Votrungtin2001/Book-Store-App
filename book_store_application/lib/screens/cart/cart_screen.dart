import 'package:flutter/material.dart';

import 'package:book_store_application/screens/cart/body.dart';
import 'package:book_store_application/screens/cart/check_out_card.dart';

class CartScreen extends StatelessWidget {
  static String routeName = "/cart";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}
