import 'package:book_store_application/MVP/Model/Author.dart';
import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:book_store_application/MVP/Model/Favorite.dart';
import 'package:book_store_application/MVP/Model/User.dart';
import 'package:book_store_application/firebase/providers/author_provider.dart';
import 'package:book_store_application/firebase/providers/favorite_provider.dart';
import 'package:book_store_application/screens/book_detail/custom_tab_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  bool isFavorite = false;
  final DatabaseReference refFavorite = FirebaseDatabase.instance.reference().child('Favorites');

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
    final user = Provider.of<User_MD?>(context);
    final currencyformat = new NumberFormat("#,###,##0");
    final authorProvider = Provider.of<AuthorProvider>(context);
    authors = authorProvider.authors;
    String user_id = "";
    int book_id = -1;
    if(user!.uid != null) user_id = user.uid.toString();
    if(book!.getID() >= 0) book_id = book!.getID();

    checkFavorite(user_id, book_id);

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RichText(
                text: TextSpan(
                  text: book!.getTITLE() + '\n',
                  style: TextStyle(fontSize: 24,fontWeight: FontWeight.w700 ,color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(text: getAuthorName(book!.getAUTHOR_ID()) + '\n', style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black12,fontSize: 16)),
                    TextSpan(text: currencyformat.format(book!.getPRICE()) + 'đ', style: TextStyle(fontWeight: FontWeight.w500,color: Colors.red,fontSize: 26)),
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
                  setState(() {
                    if(isFavorite == false) {
                      isFavorite = true;
                      refFavorite.child(user_id).child('book_id')
                          .update({book_id.toString(): book_id});
                      Fluttertoast.showToast(
                          msg: 'Added this book in your favorite list.',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM);
                    }
                    else {
                      isFavorite = false;
                      refFavorite.child(user_id).child('book_id').child(book_id.toString())
                          .remove();
                      Fluttertoast.showToast(
                          msg: 'Removed this book in your favorite list.',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM);
                    }
                  });
                },

                    icon: Icon(Icons.favorite_rounded, color: isFavorite ? Colors.red : Colors.white)),
              ),
            ),
          ],
      ),
    );

  }

  void checkFavorite(String USER_ID, int BOOK_ID) {
    refFavorite.child(USER_ID).child('book_id')
        .child(BOOK_ID.toString()).once().then((DataSnapshot dataSnapshot) {
      if(dataSnapshot.exists) {
        setState(() {
          isFavorite = true;
        });
      }
      else {
        setState(() {
          isFavorite = false;
        });
      }
    });
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