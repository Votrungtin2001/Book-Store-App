import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:book_store_application/screens/book_detail/top_rounded_container.dart';
import 'package:book_store_application/screens/cart/cart_screen.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import 'book_description.dart';
import 'book_image.dart';
import 'add_to_cart.dart';
import 'custom_tab_bar.dart';

class Body extends StatefulWidget {
  Book? book;

  Body(Book? book) {
    this.book = book;
  }

  @override
  _BodyState createState() => _BodyState(book);
}

class _BodyState extends State<Body> {
  Book? book;

  _BodyState(Book? book) {
    this.book = book;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          getAppBarUI(),
          BookImages(book),
          Expanded(
              child: SingleChildScrollView(
                child: TopRoundedContainer(
                  color: Colors.white,
                  child: Column(
                    children: [
                      BookDescription(book),
                      TopRoundedContainer(
                        color: const Color(0xFFF6F7F9),
                        child: Column(
                          children: [
                            AddToCart(book),
                            TopRoundedContainer(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 5, right: 5,),
                                child: CustomTabBar(book),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }

  Widget getAppBarUI() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 2, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(32.0),),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      child: Row(
                        children: const [
                          Icon(
                            Icons.navigate_before, color: Colors.black, size: 25,),
                          Text("Back", style: TextStyle(color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),)
                        ],
                      ),
                      onPressed: () { Navigator.pop(context);},
                    )
                  ),
                ),
              ),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'Book Detail',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,

                  ),
                ),
              ),
            ),
            SizedBox(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                      onTap: () {
                        Navigator.push( context,
                          MaterialPageRoute(
                              builder: (context) => CartScreen()
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon( Icons.shopping_bag_outlined ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}



