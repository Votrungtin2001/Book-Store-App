import 'package:book_store_application/MVP/Model/Author.dart';
import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:book_store_application/MVP/Model/User.dart';
import 'package:book_store_application/firebase/providers/author_provider.dart';
import 'package:book_store_application/firebase/providers/books_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class FavouriteBookListView extends StatefulWidget {
  FavouriteBookListView({Key? key, this.callBack, this.favorites}) : super(key: key);
  final Function()? callBack;
  final List<int>? favorites;

  @override
  _FavouriteBookListViewState createState() => _FavouriteBookListViewState(this.favorites);
}

class _FavouriteBookListViewState extends State<FavouriteBookListView>  with TickerProviderStateMixin {
  final DatabaseReference refFavorite = FirebaseDatabase.instance.reference().child('Favorites');
  AnimationController? animationController;
  List<int>? favorites;
  _FavouriteBookListViewState(List<int>? list) {
    this.favorites = list;
  }
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User_MD?>(context);
    String user_id = "";
    if(user!.uid != null) user_id = user.uid.toString();
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: FutureBuilder(
        future: getFavorites(user_id),
        builder: (BuildContext context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else {
            var books = snapshot.data as List<int>;
            if(books.length < favorites!.length) books = favorites!;
            return GridView(
              padding: const EdgeInsets.all(8),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: List<Widget>.generate(
                books.length,
                    (int index) {
                  final int count =  books.length;
                  final Animation<double> animation =
                  Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animationController!,
                      curve: Interval((1 / count) * index, 1.0,
                          curve: Curves.fastOutSlowIn),
                    ),
                  );
                  animationController?.forward();
                  return FavouriteView(
                    callback: widget.callBack,
                    book_id: books[index],
                    animation: animation,
                    animationController: animationController,
                  );
                },
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 32.0,
                crossAxisSpacing: 32.0,
                childAspectRatio: 0.8,
              ),
            );
          }
        },
      ),
    );
  }
  Future<List<int>> getFavorites(String User_ID) async {
    List<int> books = [];
    refFavorite.child(User_ID).child('book_id').once().then((DataSnapshot snapshot){
      Map<String, dynamic> json = Map.from(snapshot.value);
      json.forEach((key, value) {
        int book_id = int.parse(value.toString());
        books.add(book_id);
      });
    });
      return books;
    }
  }


class FavouriteView extends StatelessWidget {
  FavouriteView({Key? key, this.book_id, this.animationController, this.animation, this.callback}) : super(key: key);

  final VoidCallback? callback;
  final int? book_id;
  final AnimationController? animationController;
  final Animation<double>? animation;

  Book book = new Book(0, 0, 0, "", [], 0, 0, 0, 0, "", "");
  List<Author> authors = [];
  final currencyformat = new NumberFormat("#,###,##0");
  @override
  Widget build(BuildContext context) {

    final booksProvider = Provider.of<BooksProvider>(context);
    for (int i = 0; i < booksProvider.books.length; i++) {
      if(booksProvider.books[i].getID() == book_id) book = booksProvider.books[i];
    }
    final authorProvider = Provider.of<AuthorProvider>(context);
    authors = authorProvider.authors;

    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(0.0, 50 * (1.0 - animation!.value), 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: callback,
              child: SizedBox(
                height: 280,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                                            child: Text(
                                              book.getTITLE(),
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                letterSpacing: 0.27,
                                                color: Colors.black,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only( top:5,left: 16, right: 16, bottom: 5),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                currencyformat.format(book.getPRICE()) + "đ",
                                                  textAlign: TextAlign.left,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    letterSpacing: 0.27,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(  left: 16, right: 16, bottom: 8),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  getAuthorName(book.getAUTHOR_ID()),
                                                  textAlign: TextAlign.left,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 12,
                                                    letterSpacing: 0.27,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 48,),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 48,),
                        ],
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only( right: 16, left: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.05),
                                  offset: const Offset(0.0, 0.0),
                                  blurRadius: 6.0),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                            child: AspectRatio(
                                aspectRatio: 1.1,
                                child: Image.network(book.getIMAGE_URL(), fit: BoxFit.cover,),
                          ),
                        ),
                      ),
                    ),
                    )],
                ),
              ),
            ),
          ),
        );
      },
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