import 'package:book_store_application/MVP/Model/Author.dart';
import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:book_store_application/firebase/providers/author_provider.dart';
import 'package:book_store_application/screens/book_detail/custom_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class BookDescription extends StatefulWidget {
  Book? book;
  BookDescription(Book? BOOK) {
    this.book = BOOK;
  }

  _BookDescriptionState createState() => _BookDescriptionState(this.book);

}

class _BookDescriptionState extends State<BookDescription> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Book? book;
  List<Author> authors = [];

  _BookDescriptionState(Book? book) {
    this.book = book;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final currencyformat = new NumberFormat("#,###,##0");
    final authorProvider = Provider.of<AuthorProvider>(context);
    authors = authorProvider.authors;
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RichText(
                text: TextSpan(
                  text: book!.getTITLE() + '\n',
                  style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(text: getAuthorName(book!.getAUTHOR_ID()) + '\n', style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black12,fontSize: 16)),
                    TextSpan(text: currencyformat.format(book!.getPRICE()) + 'đ', style: TextStyle(fontWeight: FontWeight.w500,color: Colors.red,fontSize: 26)),
                  ],
                ),
              )
            ),
            Spacer(),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.all(12),
                width: 56,
                // decoration: const BoxDecoration(
                //   color: Colors.black12,
                //   borderRadius: BorderRadius.only(
                //     topLeft: Radius.circular(15),
                //     bottomLeft: Radius.circular(15),
                //   ),
                // ),
                child: Image.asset(
                  "assets/icons/heart.svg",
                  height: 24,
                ),
              ),
            ),

          ],
      ),
    );

  }

  String getAuthorName(int author_id) {
    for(int i = 0; i < authors.length; i++) {
      if(authors[i].getID() == author_id) {
        return authors[i].getNAME();
      }
    }
    return "";
  }

}