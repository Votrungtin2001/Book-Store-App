import 'package:book_store_application/MVP/Model/Author.dart';
import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:book_store_application/MVP/Model/Publisher.dart';
import 'package:book_store_application/MVP/Presenter/category_presenter.dart';
import 'package:book_store_application/firebase/providers/author_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'book_list_view.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  AnimationController? animationController;

  List<Book> booksOfPublisher = [];
  List<Book> booksOfAuthor = [];
  List<Author> authors = [];
  List<Book> books = [];

  String defaultAuthor = "";
  int author_id = 1;


  int selectedCategory = 0;
  List<String> categories = ["Category", "Authors", "Publisher"];
  Type categoryType = Type.type1;

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {

    final authorProvider = Provider.of<AuthorProvider>(context);
    authors = authorProvider.authors;
    if(defaultAuthor == "") defaultAuthor = getAuthorName(1);

    return Scaffold(
      body: Stack(
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
                                              text: const TextSpan(
                                                  text: 'Hello there, Minh Thi\n',
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
                                   // const SizedBox(height: 5,),
                                   // BooksListView(),
                                    BookListViewAdmin(),
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
                          child: Container(),
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
                        icon: Icon(Icons.menu)),
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
                      // showSearch(context: context, delegate: DataSearch(presenter.books, presenter.suggestionBook, presenter.authors));
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon( Icons.search_outlined ),
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

  Padding buildCategory(int index, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedCategory = index;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              categories[index],
              style: Theme.of(context).textTheme.headline5!.copyWith(
                fontWeight: FontWeight.w600,
                color: index == selectedCategory
                    ? Colors.blue
                    : Colors.black.withOpacity(0.4),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20 / 2),
              height: 6,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: index == selectedCategory
                    ? Colors.black
                    : Colors.transparent,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getButtonCategory(Type categoryTypeData, bool isSelected) {
    String txt = '';
    if (Type.type1 == categoryTypeData) {
      txt = '112';
    } else if (Type.type2 == categoryTypeData) {
      txt = '2224422';
    } else if (Type.type3 == categoryTypeData) {
      txt = '111 224222';
    }else if (Type.type4 == categoryTypeData) {
      txt = '1 2 3 44';
    }else if (Type.type5 == categoryTypeData) {
      txt = 'zz4z zzz';
    }
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: isSelected
                ? Colors.orange
                : Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            border: Border.all(color: Colors.orange)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.white24,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            onTap: () {
              setState(() {
                categoryType = categoryTypeData;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 12, bottom: 12, left: 18, right: 18),
              child: Center(
                child: Text(
                  txt,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.27,
                    color: isSelected
                        ? Colors.white
                        : Colors.orange,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getButtonAuthors(String authorName, bool isSelected) {
    String txt = '';
    int index = 0;

    if (getAuthorName(1) == authorName) {
      txt = getAuthorName(1);
      index = 0;
    } else if (getAuthorName(2) == authorName) {
      txt = getAuthorName(2);
      index = 1;
    } else if (getAuthorName(3) == authorName) {
      txt = getAuthorName(3);
      index = 2;
    }

    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Container(
        decoration: BoxDecoration(
            color: isSelected
                ? Colors.blueAccent
                : Colors.white70,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            border: Border.all(color: Colors.lightBlueAccent)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.white24,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            onTap: () {
              setState(() {
                defaultAuthor = authorName;
                author_id = authors[index].getID();
                getBooksOfAuthor(author_id);
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 6, left: 15, right: 15),
              child: Center(
                child: Text(
                  txt,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.27,
                    color: isSelected
                        ? Colors.white
                        : Colors.lightBlueAccent,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getButtonPublisher(Type categoryTypeData, bool isSelected) {
    String txt = '';
    if (Type.type1 == categoryTypeData) {
      txt = 'UUU';
    } else if (Type.type2 == categoryTypeData) {
      txt = 'BBBBBBBBBB';
    } else if (Type.type3 == categoryTypeData) {
      txt = 'ZZz zzz';
    }
    else if (Type.type4 == categoryTypeData) {
      txt = 'ZZz zZZ';
    }
    else if (Type.type5 == categoryTypeData) {
      txt = 'ZZz zzz zZZ';
    }
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: isSelected
                ? Colors.orange
                : Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            border: Border.all(color: Colors.orange)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.white24,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            onTap: () {
              setState(() {
                categoryType = categoryTypeData;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 12, bottom: 12, left: 18, right: 18),
              child: Center(
                child: Text(
                  txt,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.27,
                    color: isSelected
                        ? Colors.white
                        : Colors.orange,
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

  void getBooksOfAuthor(int author_id) {
    List<Book> list = [];
    if(author_id == 0) booksOfAuthor = books;
    else {
      for(int i = 0; i < books.length; i++) {
        if(books[i].getAUTHOR_ID() == author_id) list.add(books[i]);
      }
      booksOfAuthor = list;
    }
  }

}




