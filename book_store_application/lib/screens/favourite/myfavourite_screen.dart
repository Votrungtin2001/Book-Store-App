import 'package:flutter/material.dart';
import 'package:book_store_application/screens/favourite/body.dart';

class MyFavouriteScreen extends StatelessWidget {
  List<int> favorites = [];
  MyFavouriteScreen(List<int> list) {
    this.favorites = list;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(this.favorites),
    );
  }
}
