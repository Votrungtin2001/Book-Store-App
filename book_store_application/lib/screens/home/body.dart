import 'package:book_store_application/MVP/Model/Author.dart';
import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:book_store_application/MVP/Model/Category.dart';
import 'package:book_store_application/MVP/Model/User.dart';
import 'package:book_store_application/MVP/Presenter/bestSeller_presenter.dart';
import 'package:book_store_application/MVP/Presenter/homeScreen_presenter.dart';
import 'package:book_store_application/MVP/View/bestSeller_view.dart';
import 'package:book_store_application/MVP/View/homeScreen_view.dart';
import 'package:book_store_application/firebase/DatabaseManager.dart';
import 'package:book_store_application/firebase/helpers/books_services.dart';
import 'package:book_store_application/firebase/providers/author_provider.dart';
import 'package:book_store_application/firebase/providers/books_provider.dart';
import 'package:book_store_application/firebase/providers/category_provider.dart';
import 'package:book_store_application/firebase/providers/order_provider.dart';
import 'package:book_store_application/firebase/providers/user_provider.dart';
import 'package:book_store_application/screens/book_detail/book_detail_screen.dart';
import 'package:book_store_application/screens/cart/cart_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'best_seller.dart';
import 'carousel.dart';
import 'book_all.dart';

class Body extends StatefulWidget {

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin implements HomeScreenView{
  AnimationController? animationController;
  final ScrollController _scrollController = ScrollController();
  // CategoryType categoryType = CategoryType.all;
  late Animation<double> _scaleAnimation;
  late Animation<double> _menuScaleAnimation;
  late Animation<Offset> _slideAnimation;
  late BooksServices booksServices;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late HomeScreenPresenter presenter;


  int category_id = 0;

  _BodyState() {
    this.presenter = new HomeScreenPresenter(this);
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User_MD?>(context);
    final user_model = Provider.of<UserProvider>(context);

    String user_id = "";
    if(user!.uid != null) user_id = user.uid.toString();
    user_model.getUser(user_id);

    presenter.getBookList();
    presenter.getSuggestionBookList();
    presenter.getAuthorList();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height,
        maxWidth: MediaQuery.of(context).size.width,
      ),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg2.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: <Widget>[
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Column(
              children: [
                getAppBarUI(),
                Expanded(
                  child: NestedScrollView(
                    headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
                      return <Widget>[
                        SliverList(delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  return Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        const SizedBox(height: 10,),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 18,),
                                          child: Column(
                                            children: [
                                              RichText(
                                                  text: TextSpan(
                                                      text: "Hello there, " + user_model.user.getName().toString() + "\n",
                                                      style: TextStyle( fontSize: 24, fontWeight: FontWeight.bold,color: Colors.black),
                                                      children: <TextSpan>[
                                                        TextSpan( text: 'Keep reading, you’ll fall in love ',
                                                            style: TextStyle( fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black)),
                                                      ]
                                                  )
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 5,),
                                        BooksListView(),
                                       // getSearchBarUI(),
                                       // const DestinationCarousel(key: null,),
                                      ]
                                  );
                                }, childCount: 1)
                        )
                      ];
                    },
                    body: Container(
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                          },
                          child: BestSeller(),
                        )
                    ),
                  ),
                ),
              ],
            ),
          )
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
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
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
                    padding: EdgeInsets.all(8.0),
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.menu,color: Colors.transparent,)),

                  ),
                ),
              ),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'bibliophile',
                  style: TextStyle(
                    fontFamily: 'AH-Little Missy',
                    fontWeight: FontWeight.w400,
                    fontSize: 36,
                  ),
                ),
              ),
            ),
            Row(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    showSearch(context: context, delegate: DataSearch(presenter.books, presenter.suggestionBook, presenter.authors));
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon( Icons.search_outlined ),
                  ),
                ),
              ),
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
            )
          ],
        ),
      ),
    );
  }

  @override
  List<Book> getBookList() {
    final booksProvider = Provider.of<BooksProvider>(context);
    return booksProvider.books;
  }

  @override
  List<Book> getSuggestionBookList() {
    final booksProvider = Provider.of<BooksProvider>(context);
    booksProvider.loadSuggestionBooks();
    return booksProvider.sugesstionBooks;
  }

  @override
  List<Author> getAuthorList() {
    final authorProvider = Provider.of<AuthorProvider>(context);
    return authorProvider.authors;
  }

}

class CategoryCard extends StatelessWidget {
  const CategoryCard({Key? key, required this.icon, required this.text, required this.press,
  }) : super(key: key);

  final String? icon, text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        width: 46,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFFFECDF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.network(icon!),
            ),
            const SizedBox(height: 5),
            Text(text!, textAlign: TextAlign.center)
          ],
        ),
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String>{

  List<Book> books = [];
  List<Book> suggestBooks = [];
  List<Author> authors = [];

  DataSearch(List<Book> list1, List<Book> list2, List<Author> list3) {
    this.books = list1;
    this.suggestBooks = list2;
    this.authors = list3;
  }

  String getAuthor(List<Author> list, int ID) {
    for(int i = 0; i < list.length; i++) {
      if(list[i].getID() == ID) return list[i].getNAME();
    }
    return "";
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
      icon: Icon(Icons.clear),
      onPressed: () {
        query = "";
      },)
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => Navigator.pop(context),
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Card(
      color: Colors.red,
      child: Center(
        child: Text(query),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Book> results = [];
   if(query.isEmpty) {
     results = suggestBooks;
   }
   else {
     List<Book> list = [];
     for (int i = 0; i < books.length; i++) {
       String search_text = query.toLowerCase();
       String name = books[i].getTITLE().toLowerCase();
       if(name.startsWith(search_text)) list.add(books[i]);
     }
     results = list;
   }
   return ListView.builder(
     itemBuilder: (context, index) => ListTile(
       onTap: ()=> Navigator.push<dynamic>(
         context,
         MaterialPageRoute<dynamic>(
           builder: (BuildContext context) => BookDetailScreen(results[index]),
         ),
       ),
     leading: Image.network(results[index].getIMAGE_URL(), fit: BoxFit.cover), // image book
     title: RichText(
       text: TextSpan(
           text: results[index].getTITLE().substring(0, query.length),
           style:TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
           children: [
             TextSpan(
               text: results[index].getTITLE().substring(query.length),
               style:TextStyle(color: Colors.grey,),
         ),
             TextSpan(
               text: '\n' + getAuthor(authors, results[index].getAUTHOR_ID()) + '\n \n',
                 style: TextStyle(color: Colors.grey)
             ),
       ]
     ),
     )
   ),
   itemCount: results.length,
   );
  }

}
