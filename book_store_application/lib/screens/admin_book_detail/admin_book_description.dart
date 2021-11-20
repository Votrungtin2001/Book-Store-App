import 'package:book_store_application/MVP/Model/Author.dart';
import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:book_store_application/firebase/providers/author_provider.dart';
import 'package:book_store_application/firebase/providers/books_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AdminBookDescription extends StatefulWidget {
  Book? book;
  AdminBookDescription(Book? BOOK) {
    this.book = BOOK;
  }

  _AdminBookDescriptionState createState() => _AdminBookDescriptionState(this.book);

}

class _AdminBookDescriptionState extends State<AdminBookDescription> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Book? book;
  List<Author> authors = [];

  _AdminBookDescriptionState(Book? book) {
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
    final booksProvider = Provider.of<BooksProvider>(context);
    int index_book = 0;
    for(int i = 0; i < booksProvider.books.length; i++) {
      if(book!.getID() == booksProvider.books[i].getID()) index_book = i;
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RichText(
                text: TextSpan(
                  text: booksProvider.books[index_book].getTITLE() + '\n',
                  style: TextStyle(fontSize: 24,fontWeight: FontWeight.w700 ,color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(text: getAuthorName(booksProvider.books[index_book].getAUTHOR_ID()) + '\n', style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black12,fontSize: 16)),
                    TextSpan(text: currencyformat.format(booksProvider.books[index_book].getPRICE()) + 'đ', style: TextStyle(fontWeight: FontWeight.w500,color: Colors.red,fontSize: 26)),
                  ],
                ),
              )
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.all(1),
              width: 42,
              decoration: const BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
              child: IconButton( onPressed: () {
              },

                  icon: Icon(Icons.favorite_rounded, color: Colors.white)),
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