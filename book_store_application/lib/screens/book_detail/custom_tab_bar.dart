import 'package:book_store_application/MVP/Model/Author.dart';
import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:book_store_application/MVP/Model/Category.dart';
import 'package:book_store_application/MVP/Model/Publisher.dart';
import 'package:book_store_application/firebase/providers/author_provider.dart';
import 'package:book_store_application/firebase/providers/category_provider.dart';
import 'package:book_store_application/firebase/providers/publisher_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomTabBar extends StatefulWidget {

  Book? book;
  CustomTabBar(Book? BOOK) {
    this.book = BOOK;
  }

  @override
  _CustomTabBarState createState() => _CustomTabBarState(this.book);
}

class _CustomTabBarState extends State<CustomTabBar> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Type type = Type.publisher;

  Book? book;
  List<Author> authors = [];
  List<Publisher> publishers = [];
  List<Category> categories = [];

  int available = 0;
  final DatabaseReference refInventory = FirebaseDatabase.instance.reference().child('Inventory');

  _CustomTabBarState(Book? BOOK) {
    this.book = BOOK;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final authorProvider = Provider.of<AuthorProvider>(context);
    final publisherProvider = Provider.of<PublisherProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    authors = authorProvider.authors;
    publishers = publisherProvider.publishers;
    categories = categoryProvider.categories;
    getQuantity(book!.getID());
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Column (
          children: <Widget>[
            TabBar(
                controller: _tabController,
                indicatorColor: Colors.transparent,
                labelColor: Colors.black,
                isScrollable: true,
                labelPadding: const EdgeInsets.only(right: 45.0),
                unselectedLabelColor: const Color(0xFFCDCDCD),
                tabs: const [
                  Tab(
                    child: Text('Description',
                        style: TextStyle(
                          fontSize: 15.0,
                        )),
                  ),
                  Tab(
                    child: Text('About Book',
                        style: TextStyle(
                          fontSize: 15.0,
                        )),
                  ),
                ]),
            SizedBox(
                height: MediaQuery.of(context).size.height,
                child: TabBarView(
                    controller: _tabController,
                    children: [
                      Text(book!.getSUMMARY()),
                      Row(
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
                          SizedBox(width: 15,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(getAuthorName(book!.getAUTHOR_ID())),
                              SizedBox(height: 15,),
                              Text(getPublisher(book!.getPUBLISHER_ID())),
                              SizedBox(height: 15,),
                              Text(book!.getPUBLISHING_YEAR().toString()),
                              SizedBox(height: 15,),
                              Text(getCategory(book!.getCATEGORY_ID())),
                              SizedBox(height: 15,),
                              Text(book!.getGENRE()),
                              SizedBox(height: 15,),
                              Text(book!.getSOLD_COUNT().toString()),
                              SizedBox(height: 15,),
                              Text(available.toString()),
                              SizedBox(height: 15,),
                              ],
                          ),
                          // getButtonUI(Type.publisher, type == Type.publisher),
                            // const SizedBox(height: 5,),
                            // const Text("2019"),
                            // const SizedBox(height: 5,),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     getButtonUI(Type.category1, type == Type.category1),
                            //     getButtonUI(Type.category, type == Type.category),
                            //   ],
                            // )
                        ],
                      ),
                    ]
                )
            )
          ]
      ),
    );
  }

  Widget getButtonUI(Type TypeData, bool isSelected) {
    String txt = '';
    if (Type.publisher == TypeData) {
      txt = 'Publisher';
    } else if (Type.category == TypeData) {
      txt = 'Fiction';
    } else if (Type.category1 == TypeData) {
      txt = 'Science Fiction';
    }
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            border: Border.all(color: Colors.lightBlueAccent)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.white24,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            onTap: () {
              setState(() {
                type = TypeData;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 6, left: 9, right: 9),
              child: Center(
                child: Text(
                  txt,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.27,
                    color: Colors.lightBlueAccent,
                  ),
                ),
              ),
            ),
          ),
        ),
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
enum Type {
  publisher,
  category,
  category1,
}



