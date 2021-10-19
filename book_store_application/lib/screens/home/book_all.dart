import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:book_store_application/MVP/Model/Category.dart';
import 'package:book_store_application/MVP/Presenter/category_presenter.dart';
import 'package:book_store_application/MVP/View/category_view.dart';
import 'package:book_store_application/firebase/providers/books_provider.dart';
import 'package:book_store_application/firebase/providers/category_provider.dart';
import 'package:book_store_application/screens/book_detail/book_detail_screen.dart';
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

  final key = GlobalKey<AnimatedListState>();

  List<Book> booksOfCategory = [];
  List<Book> books = [];
  int category_id = 0;

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
}

class BooksOfCategoryView extends StatelessWidget {
  const BooksOfCategoryView(
      {Key? key,
        this.book,
        this.animationController,
        this.animation})
      : super(key: key);

  final Book? book;
  final AnimationController? animationController;
  final Animation<double>? animation;

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
                                              '${book!.getQUANTITY()} left',
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