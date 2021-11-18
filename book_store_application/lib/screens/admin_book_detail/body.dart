import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:book_store_application/screens/admin_book_detail/admin_book_description.dart';
import 'package:book_store_application/screens/admin_book_detail/admin_book_image.dart';
import 'package:book_store_application/screens/admin_book_detail/admin_custom_tab_bar.dart';
import 'package:book_store_application/screens/admin_book_detail/admin_edit_book_button.dart';
import 'package:book_store_application/screens/book_detail/book_image.dart';
import 'package:book_store_application/screens/book_detail/custom_tab_bar.dart';
import 'package:book_store_application/screens/book_detail/top_rounded_container.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  Book? book;
  String? category;
  String? author;
  String? publisher;
  Body(Book? book, String? category, String? author, String? publisher) {
    this.book = book;
    this.category = category;
    this.author = author;
    this.publisher = publisher;
  }

  @override
  _BodyState createState() => _BodyState(this.book, this.category, this.author, this.publisher);
}

class _BodyState extends State<Body> {
  Book? book;
  String? category;
  String? author;
  String? publisher;

  _BodyState(Book? book, String? category, String? author, String? publisher) {
    this.book = book;
    this.category = category;
    this.author = author;
    this.publisher = publisher;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          getAppBarUI(),
          AdminBookImages(book),
          Expanded(
              child: SingleChildScrollView(
                child: TopRoundedContainer(
                  color: Colors.white,
                  child: Column(
                    children: [
                      AdminBookDescription(book),
                      TopRoundedContainer(
                        color: const Color(0xFFF6F7F9),
                        child: Column(
                          children: [
                            AdminEditBookButton(book, category, author, publisher),
                            TopRoundedContainer(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 5, right: 5,),
                                child: AdminCustomTabBar(book),
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
          ],
        ),
      ),
    );
  }
}