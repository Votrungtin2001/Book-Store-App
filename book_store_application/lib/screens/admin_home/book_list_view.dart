import 'package:book_store_application/MVP/Model/Author.dart';
import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:book_store_application/MVP/Model/Publisher.dart';
import 'package:book_store_application/MVP/Presenter/category_presenter.dart';
import 'package:book_store_application/firebase/providers/author_provider.dart';
import 'package:book_store_application/firebase/providers/publisher_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'demo_list.dart';

class BookListViewAdmin extends StatefulWidget {
  const BookListViewAdmin({Key? key, this.callBack}) : super(key: key);
  final Function()? callBack;

  @override
  _BookListViewAdminState createState() => _BookListViewAdminState();
}

class _BookListViewAdminState extends State<BookListViewAdmin> {
  AnimationController? animationController;

  List<Book> booksOfCategory = [];
  List<Book> booksOfAuthor = [];
  List<Book> booksOfPublisher = [];
  List<Book> books = [];
  List<Author> authors = [];
  List<Publisher> publishers = [];
  int category_id = 0;
  int author_id = 1;
  int publisher_id = 1;

  int quantity = 0;

  String defaultAuthor = "";
  String defaultPublisher = "";


  int selectedCategory = 0;
  List<String> categories = ["Category", "Authors", "Publisher"];
  Type categoryType = Type.type1;

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  void getBooksOfPublisher(int publisher_id) {
    List<Book> list = [];
    if(publisher_id == 0) booksOfPublisher = books;
    else {
      for(int i = 0; i < books.length; i++) {
        if(books[i].getPUBLISHER_ID() == publisher_id) list.add(books[i]);
      }
      booksOfPublisher = list;
    }
  }

  @override
  Widget build(BuildContext context) {

    final authorProvider = Provider.of<AuthorProvider>(context);
    authors = authorProvider.authors;
    if(defaultAuthor == "") defaultAuthor = getAuthorName(1);

    final publisherProvider = Provider.of<PublisherProvider>(context);
    publishers = publisherProvider.publishers;
    if(defaultPublisher == "") defaultPublisher = getPublisherName(1);
    if(publisher_id == 1) getBooksOfPublisher(publisher_id);

    return Column(
          children:[
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              height: 47,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) => buildCategory(index, context),
              ),
            ),
            Container(
              height: 30,
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  children:[
                    getButtonPublisher(getPublisherName(1), defaultPublisher == getPublisherName(1)),
                    const SizedBox(width: 16,),
                    getButtonPublisher(getPublisherName(2), defaultPublisher == getPublisherName(2)),
                    const SizedBox(width: 16,),
                    getButtonPublisher(getPublisherName(3), defaultPublisher == getPublisherName(3)),
                    const SizedBox(width: 16,),
                  ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.only( bottom: 16),
              child: SizedBox(
                height: 134,
                width: double.infinity,
                child: FutureBuilder<bool>(
                  future: getData(),
                  builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox();
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 0, bottom: 0, right: 16, left: 16),
                        itemCount: booksOfPublisher.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          int count = booksOfPublisher.length > 10
                              ? 10
                              : booksOfPublisher.length;
                          final Animation<double> animation =
                          Tween<double>(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
                                  parent: animationController!,
                                  curve: Interval((1 / count) * index, 1.0, curve: Curves.fastOutSlowIn))
                          );
                          animationController?.forward();
                          return BooksOfPublisherView(
                            book: booksOfPublisher[index],
                            author: getAuthorName(booksOfPublisher[index].getAUTHOR_ID()),
                            animation: animation,
                            animationController: animationController,
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ]
    );
  }

  Padding buildCategory(int index, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
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
              margin: EdgeInsets.symmetric(vertical: 5),
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

  Widget getButtonPublisher(String publisherName, bool isSelected) {
    String txt = '';
    int index = 0;

    if (getPublisherName(1) == publisherName) {
      txt = getPublisherName(1);
      index = 0;
    } else if (getPublisherName(2) == publisherName) {
      txt = getPublisherName(2);
      index = 1;
    } else if (getPublisherName(3) == publisherName) {
      txt = getPublisherName(3);
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
                defaultPublisher = publisherName;
                publisher_id = publishers[index].getID();
                getBooksOfPublisher(publisher_id);
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

  String getPublisherName(int publisher_id) {
    for(int i = 0; i < publishers.length; i++) {
      if(publishers[i].getID() == publisher_id) {
        return publishers[i].getNAME();
      }
    }
    return "";
  }

}

enum Type {
  type1,
  type2,
  type3,
  type4,
  type5,
}

class CategoryView extends StatelessWidget {
  const CategoryView(
      {Key? key,
        this.category,
        this.animationController,
        this.animation,
        this.callback})
      : super(key: key);

  final VoidCallback? callback;
  final Category? category;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - animation!.value), 0.0, 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: callback,
              child: SizedBox(
                width: 280,
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          const SizedBox(
                            width: 48,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(16.0)),
                              ),
                              child: Row(
                                children: <Widget>[
                                  const SizedBox(
                                    width: 48 + 24.0,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(top: 16),
                                            child: Text(
                                              category!.title,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                letterSpacing: 0.27,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          const Expanded(
                                            child: SizedBox(),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 16, bottom: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  '${category!.lessonCount} lesson',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 12,
                                                    letterSpacing: 0.27,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Container(
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                        '${category!.rating}',
                                                        textAlign:
                                                        TextAlign.left,
                                                        style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.w200,
                                                          fontSize: 18,
                                                          letterSpacing: 0.27,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons.star,
                                                        color:
                                                        Colors.blue,
                                                        size: 20,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 16, right: 16),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  '\$${category!.money}',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18,
                                                    letterSpacing: 0.27,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(
                                                            8.0)),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        4.0),
                                                    child: Icon(
                                                      Icons.add,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 24, bottom: 24, left: 16),
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius:
                              const BorderRadius.all(Radius.circular(16.0)),
                              child: AspectRatio(
                                  aspectRatio: 1.0,
                                  child: Image.asset(category!.imagePath)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class BooksOfCategoryView extends StatelessWidget {
  BooksOfCategoryView(
      {Key? key,
        this.book,
        this.author,
        this.animationController,
        this.animation})
      : super(key: key);

  final Book? book;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final String? author;

  @override
  Widget build(BuildContext context) {
    final currencyformat = new NumberFormat("#,###,##0");
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - animation!.value), 0.0, 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: (){},
              // => Navigator.push<dynamic>(
              //   context,
              //   MaterialPageRoute<dynamic>(
              //     builder: (BuildContext context) => BookDetailScreen(book),
              //   ),
              // ),
              child: SizedBox(
                width: 280,
                child: Stack(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const SizedBox(
                          width: 48,
                        ),
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0x00f8fafb),
                              borderRadius: BorderRadius.all(Radius.circular(16.0)),
                            ),
                            child: Row(
                              children: <Widget>[
                                const SizedBox(width: 48 + 24.0,),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(top: 16),
                                        child: Text(
                                          book!.title,
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            letterSpacing: 0.27,
                                            color: Colors.black,
                                          ),
                                          maxLines: 1,
                                        ),
                                      ),
                                      const Expanded(
                                        child: SizedBox(),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 16, bottom: 8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              '${author}',
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w200,
                                                fontSize: 12,
                                                letterSpacing: 0.27,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Container(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                borderRadius: const BorderRadius.all(
                                                  Radius.circular(32.0),
                                                ),
                                                onTap: () {},
                                                child: const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Icon(Icons.favorite_border_outlined),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 16, right: 16),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(currencyformat.format(book!.getPRICE()) + "đ",
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                                letterSpacing: 0.27,
                                                color: Colors.lightBlueAccent,
                                              ),
                                            ),
                                            // Container(
                                            //   decoration: const BoxDecoration(
                                            //     color: Colors.lightBlueAccent,
                                            //     borderRadius:
                                            //     BorderRadius.all(Radius.circular(10.0)),
                                            //   ),
                                            //   child: const Padding(
                                            //     padding:
                                            //     EdgeInsets.all(4.0),
                                            //     child: Icon(
                                            //       Icons.add,
                                            //       color: Colors.white,
                                            //     ),
                                            //   ),
                                            // )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 12),
                      child: Row(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(0.0)),
                            child: AspectRatio(aspectRatio: 1.0, child: Image.network(book!.getIMAGE_URL())),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class BooksOfAuthorView extends StatelessWidget {
  BooksOfAuthorView({Key? key, this.book, this.author, this.animationController, this.animation}) : super(key: key);

  final Book? book;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final String? author;
  @override
  Widget build(BuildContext context) {
    final currencyformat = new NumberFormat("#,###,##0");
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - animation!.value), 0.0, 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () {},
              // => Navigator.push<dynamic>(
              //   context,
              //   MaterialPageRoute<dynamic>(
              //     builder: (BuildContext context) => BookDetailScreen(book),
              //   ),
              // ),
              child: SizedBox(
                width: 280,
                child: Stack(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const SizedBox(
                          width: 48,
                        ),
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0x00f8fafb),
                              borderRadius: BorderRadius.all(Radius.circular(16.0)),
                            ),
                            child: Row(
                              children: <Widget>[
                                const SizedBox(width: 48 + 24.0,),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(top: 16),
                                        child: Text(
                                          book!.title,
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            letterSpacing: 0.27,
                                            color: Colors.black,
                                          ),
                                          maxLines: 1,
                                        ),
                                      ),
                                      const Expanded(
                                        child: SizedBox(),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 16, bottom: 8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              '${author}',
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w200,
                                                fontSize: 12,
                                                letterSpacing: 0.27,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Container(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                borderRadius: const BorderRadius.all(
                                                  Radius.circular(32.0),
                                                ),
                                                onTap: () {},
                                                child: const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Icon(Icons.favorite_border_outlined),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 16, right: 16),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(currencyformat.format(book!.getPRICE()) + "đ",
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                                letterSpacing: 0.27,
                                                color: Colors.lightBlueAccent,
                                              ),
                                            ),
                                            // Container(
                                            //   decoration: const BoxDecoration(
                                            //     color: Colors.lightBlueAccent,
                                            //     borderRadius:
                                            //     BorderRadius.all(Radius.circular(10.0)),
                                            //   ),
                                            //   child: const Padding(
                                            //     padding: EdgeInsets.all(4.0),
                                            //     child: Icon(
                                            //       Icons.add,
                                            //       color: Colors.white,
                                            //     ),
                                            //   ),
                                            // )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 12),
                      child: Row(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(0.0)),
                            child: AspectRatio(aspectRatio: 1.0, child: Image.network(book!.getIMAGE_URL())),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class BooksOfPublisherView extends StatelessWidget {
  BooksOfPublisherView({Key? key, this.book, this.author, this.animationController,this.animation}) : super(key: key);

  final Book? book;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final String? author;

  @override
  Widget build(BuildContext context) {
    final currencyformat = new NumberFormat("#,###,##0");
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - animation!.value), 0.0, 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: (){},
              // => Navigator.push<dynamic>(
              //   context,
              //   MaterialPageRoute<dynamic>(
              //     builder: (BuildContext context) => BookDetailScreen(book),
              //   ),
              // ),
              child: SizedBox(
                width: 280,
                child: Stack(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const SizedBox(
                          width: 48,
                        ),
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0x00f8fafb),
                              borderRadius: BorderRadius.all(Radius.circular(16.0)),
                            ),
                            child: Row(
                              children: <Widget>[
                                const SizedBox(width: 48 + 24.0,),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(top: 16),
                                        child: Text(
                                          book!.title,
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            letterSpacing: 0.27,
                                            color: Colors.black,
                                          ),
                                          maxLines: 1,
                                        ),
                                      ),
                                      const Expanded(
                                        child: SizedBox(),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 16, bottom: 8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              '${author}',
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w200,
                                                fontSize: 12,
                                                letterSpacing: 0.27,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Container(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                borderRadius: const BorderRadius.all(
                                                  Radius.circular(32.0),
                                                ),
                                                onTap: () {},
                                                child: const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Icon(Icons.favorite_border_outlined),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 16, right: 16),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(currencyformat.format(book!.getPRICE()) + "đ",
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                                letterSpacing: 0.27,
                                                color: Colors.lightBlueAccent,
                                              ),
                                            ),
                                            // Container(
                                            //   decoration: const BoxDecoration(
                                            //     color: Colors.lightBlueAccent,
                                            //     borderRadius:
                                            //     BorderRadius.all(Radius.circular(10.0)),
                                            //   ),
                                            //   child: const Padding(
                                            //     padding:
                                            //     EdgeInsets.all(4.0),
                                            //     child: Icon(
                                            //       Icons.add,
                                            //       color: Colors.white,
                                            //     ),
                                            //   ),
                                            // )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 12),
                      child: Row(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(0.0)),
                            child: AspectRatio(aspectRatio: 1.0, child: Image.network(book!.getIMAGE_URL())),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

