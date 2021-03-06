import 'package:book_store_application/MVP/Model/Author.dart';
import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:book_store_application/MVP/Model/Category.dart';
import 'package:book_store_application/MVP/Model/Publisher.dart';
import 'package:book_store_application/firebase/providers/author_provider.dart';
import 'package:book_store_application/firebase/providers/books_provider.dart';
import 'package:book_store_application/firebase/providers/category_provider.dart';
import 'package:book_store_application/firebase/providers/publisher_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminCustomTabBar extends StatefulWidget {

  Book? book;
  AdminCustomTabBar(Book? BOOK) {
    this.book = BOOK;
  }

  @override
  _AdminCustomTabBarState createState() => _AdminCustomTabBarState(this.book);
}

class _AdminCustomTabBarState extends State<AdminCustomTabBar> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  Book? book;
  List<Author> authors = [];
  List<Publisher> publishers = [];
  List<Category> categories = [];

  int available = 0;
  final DatabaseReference refInventory = FirebaseDatabase.instance.reference().child('Inventory');

  _AdminCustomTabBarState(Book? BOOK) {
    this.book = BOOK;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final booksProvider = Provider.of<BooksProvider>(context);
    int index_book = 0;
    for(int i = 0; i < booksProvider.books.length; i++) {
      if(book!.getID() == booksProvider.books[i].getID()) index_book = i;
    }
    final authorProvider = Provider.of<AuthorProvider>(context);
    final publisherProvider = Provider.of<PublisherProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    authors = authorProvider.authors;
    publishers = publisherProvider.publishers;
    categories = categoryProvider.categories;

    getQuantity(booksProvider.books[index_book].getID());

    return Container(
      height: MediaQuery.of(context).size.height - 326,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.only(left: 10.0),
      child: Column (
          children: <Widget>[
            TabBar(
                controller: _tabController,
                indicatorColor: Colors.transparent,
                labelColor: Colors.black,
                isScrollable: true,
                labelPadding: const EdgeInsets.only(right: 45.0),
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(
                    child: Text(
                        'Description',
                        style: TextStyle(fontSize: 15.0,)
                    ),
                  ),
                  Tab(
                    child: Text(
                        'About Book',
                        style: TextStyle(fontSize: 15.0,)
                    ),
                  ),
                ]
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height - 374,
                child: TabBarView(
                    controller: _tabController,
                    children: [
                      Text(book!.getSUMMARY()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Author:"),
                                SizedBox(height: 15,),
                                Text("Publisher:"),
                                SizedBox(height: 15,),
                                Text("Publishing Year:"),
                                SizedBox(height: 15,),
                                Text("Category:"),
                                SizedBox(height: 15,),
                                Text("Genre:"),
                                SizedBox(height: 15,),
                                Text("Sold:"),
                                SizedBox(height: 15,),
                                Text("Avaiable:"),
                              ],
                            ),
                            Spacer(),
                            // SizedBox(width: 15,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(getAuthorName(booksProvider.books[index_book].getAUTHOR_ID())),
                                SizedBox(height: 15,),
                                Text(getPublisher(booksProvider.books[index_book].getPUBLISHER_ID())),
                                SizedBox(height: 15,),
                                Text(booksProvider.books[index_book].getPUBLISHING_YEAR().toString()),
                                SizedBox(height: 15,),
                                Text(getCategory(booksProvider.books[index_book].getCATEGORY_ID())),
                                SizedBox(height: 15,),
                                Text(booksProvider.books[index_book].getGENRE()),
                                SizedBox(height: 15,),
                                Text(booksProvider.books[index_book].getSOLD_COUNT().toString()),
                                SizedBox(height: 15,),
                                Text(available.toString()),
                                SizedBox(height: 15,),
                              ],
                            ),
                          ],
                        ),
                      )
                    ]
                )
            )
          ]
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

  String getPublisher(int publisher_id) {
    for(int i = 0; i < publishers.length; i++) {
      if(publishers[i].getID() == publisher_id) {
        return publishers[i].getNAME();
      }
    }
    return "";
  }

  String getCategory(int category_id) {
    for(int i = 0; i < categories.length; i++) {
      if(categories[i].getID() == category_id) {
        return categories[i].getNAME();
      }
    }
    return "";
  }

  void getQuantity(int book_id) {
    refInventory.child(book_id.toString())
        .once().then((DataSnapshot dataSnapshot) {
      if(dataSnapshot.exists) {
        setState(() {
          available = dataSnapshot.value['quantity'];
        });
      }
    });
  }

}