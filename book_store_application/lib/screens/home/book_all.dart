import 'package:book_store_application/MVP/Model/Author.dart';
import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:book_store_application/MVP/Model/Category.dart';
import 'package:book_store_application/MVP/Model/Publisher.dart';
import 'package:book_store_application/MVP/Presenter/category_presenter.dart';
import 'package:book_store_application/MVP/View/category_view.dart';
import 'package:book_store_application/firebase/providers/author_provider.dart';
import 'package:book_store_application/firebase/providers/books_provider.dart';
import 'package:book_store_application/firebase/providers/category_provider.dart';
import 'package:book_store_application/firebase/providers/publisher_provider.dart';
import 'package:book_store_application/screens/book_detail/book_detail_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BooksListView extends StatefulWidget {

  @override
  _BooksListViewState createState() => _BooksListViewState();
}

class _BooksListViewState extends State<BooksListView> with TickerProviderStateMixin implements CategoryView  {
  AnimationController? animationController;
  late CategoryPresenter presenter;

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

  _BooksListViewState() {
    this.presenter = new CategoryPresenter(this);
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    presenter.getCategoryList();
    presenter.getBookList();
    books = presenter.books;
    if(category_id == 0) booksOfCategory = books;

    final authorProvider = Provider.of<AuthorProvider>(context);
    authors = authorProvider.authors;
    if(defaultAuthor == "") defaultAuthor = getAuthorName(1);
    if(author_id == 1) getBooksOfAuthor(author_id);

    final publisherProvider = Provider.of<PublisherProvider>(context);
    publishers = publisherProvider.publishers;
    if(defaultPublisher == "") defaultPublisher = getPublisherName(1);
    if(publisher_id == 1) getBooksOfPublisher(publisher_id);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.only( left: 18, right: 16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text( 'Category',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 26,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                      onPressed: () {  },
                      child: Row(
                        children: const [
                          Text('See all',style:TextStyle(color: Colors.black12)),
                          Icon(Icons.arrow_forward_ios_outlined, size:15, color: Colors.black12)
                        ],
                      )
                  )
                ]
            )
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              presenter.categories.length,
                  (index) => CategoryCard(
                icon: presenter.categories[index].getIMAGE_URL(),
                text: presenter.categories[index].getNAME(),
                press: () {
                  setState(() {
                    category_id = presenter.categories[index].getID();
                    getBooksOfCategory(category_id);
                    print('leng: ' + booksOfCategory.length.toString());
                  });
                },
              ),
            ),
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
                    itemCount: booksOfCategory.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      int count = booksOfCategory.length > 10
                          ? 10
                          : booksOfCategory.length;
                      final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: animationController!,
                              curve: Interval((1 / count) * index, 1.0, curve: Curves.fastOutSlowIn)));
                      animationController?.forward();
                      return BooksOfCategoryView(
                        book: booksOfCategory[index],
                        author: getAuthorName(booksOfCategory[index].getAUTHOR_ID()),
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
        Padding(
            padding: const EdgeInsets.only( left: 18, right: 16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text( 'Authors',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 26,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                      onPressed: () {},
                      child: Row(
                        children: const [
                          Text('See all',style:TextStyle(color: Colors.black12)),
                          Icon(Icons.arrow_forward_ios_outlined, size:15, color: Colors.black12)
                        ],
                      )
                  )
                ]
            )
        ),
        Container(
          height: 30,
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: ListView(
            scrollDirection: Axis.horizontal,
              children:[
                getButtonAuthors(getAuthorName(1), defaultAuthor == getAuthorName(1)),
                const SizedBox(width: 16,),
                getButtonAuthors(getAuthorName(2), defaultAuthor == getAuthorName(2)),
                const SizedBox(width: 16,),
                getButtonAuthors(getAuthorName(3), defaultAuthor == getAuthorName(3)),
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
                    itemCount: booksOfAuthor.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      int count = booksOfAuthor.length > 10
                          ? 10
                          : booksOfAuthor.length;
                      final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: animationController!,
                              curve: Interval((1 / count) * index, 1.0, curve: Curves.fastOutSlowIn)));
                      animationController?.forward();
                      return BooksOfAuthorView(
                        book: booksOfAuthor[index],
                        author: getAuthorName(booksOfAuthor[index].getAUTHOR_ID()),
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
        Padding(
            padding: const EdgeInsets.only( left: 18, right: 16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text( 'Publisher',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 26,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                      onPressed: () {  },
                      child: Row(
                        children: const [
                          Text('See all',style:TextStyle(color: Colors.black12)),
                          Icon(Icons.arrow_forward_ios_outlined, size:15, color: Colors.black12)
                        ],
                      )
                  )
                ]
            )
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
                              curve: Interval((1 / count) * index, 1.0, curve: Curves.fastOutSlowIn)));
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
      ],
    );
  }

  void getBooksOfCategory(int category_id) {
    List<Book> list = [];
    if(category_id == 0) booksOfCategory = books;
    else {
      for(int i = 0; i < books.length; i++) {
        if(books[i].getCATEGORY_ID() == category_id) list.add(books[i]);
      }
      booksOfCategory = list;
    }
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
  List<Category> getCategoryList() {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    return categoryProvider.categories;
  }

  @override
  List<Book> getBookList() {
    final booksProvider = Provider.of<BooksProvider>(context);
    return booksProvider.books;
  }

  String getAuthorName(int author_id) {
    for(int i = 0; i < authors.length; i++) {
      if(authors[i].getID() == author_id) {
        return authors[i].getNAME();
      }
    }
    return "";
  }

  String getPublisherName(int publisher_id) {
    for(int i = 0; i < publishers.length; i++) {
      if(publishers[i].getID() == publisher_id) {
        return publishers[i].getNAME();
      }
    }
    return "";
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
              onTap: () => Navigator.push<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => BookDetailScreen(book),
                ),
              ),
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
                                            Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.lightBlueAccent,
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(10.0)),
                                              ),
                                              child: const Padding(
                                                padding:
                                                EdgeInsets.all(4.0),
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
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
              onTap: () => Navigator.push<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => BookDetailScreen(book),
                ),
              ),
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
                                            Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.lightBlueAccent,
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(10.0)),
                                              ),
                                              child: const Padding(
                                                padding:
                                                EdgeInsets.all(4.0),
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
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
              onTap: () => Navigator.push<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => BookDetailScreen(book),
                ),
              ),
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
                                            Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.lightBlueAccent,
                                                borderRadius:
                                                BorderRadius.all(Radius.circular(10.0)),
                                              ),
                                              child: const Padding(
                                                padding:
                                                EdgeInsets.all(4.0),
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
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
                color: Colors.lightBlueAccent,
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


