import 'package:book_store_application/MVP/Model/Author.dart';
import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:book_store_application/MVP/Model/Category.dart';
import 'package:book_store_application/MVP/Presenter/bestSeller_presenter.dart';
import 'package:book_store_application/MVP/Presenter/homeScreen_presenter.dart';
import 'package:book_store_application/MVP/View/bestSeller_view.dart';
import 'package:book_store_application/MVP/View/homeScreen_view.dart';
import 'package:book_store_application/firebase/DatabaseManager.dart';
import 'package:book_store_application/firebase/helpers/books_services.dart';
import 'package:book_store_application/firebase/providers/author_provider.dart';
import 'package:book_store_application/firebase/providers/books_provider.dart';
import 'package:book_store_application/firebase/providers/category_provider.dart';
import 'package:book_store_application/screens/book_detail/book_detail_screen.dart';
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
  CategoryType categoryType = CategoryType.all;
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
    presenter.getCategoryList();
    presenter.getBookList();
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
                                        const SizedBox(height: 5,),
                                        getSearchBarUI(),
                                        getCategory(),
                                        const DestinationCarousel(key: null,),
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

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child:
          TextFormField(
            style: const TextStyle(fontSize: 16,),
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                fillColor: Colors.transparent,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                        color: Colors.black)
                ),
                filled: true,
                hintText: "Search your book..",
                hintStyle: const TextStyle(color: Colors.black38),
                prefixIcon: const Icon(Icons.search, color: Colors.black,)
            ),
          ),
    );
  }

  Widget getCategory() {
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
                },
              ),
            ),
          ),
        ),
        BooksListView(),
      ],
    );
  }

  /*void moveTo() {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => BookDetailScreen(),
      ),
    );
  }*/

  Widget getButtonUI(CategoryType categoryTypeData, bool isSelected) {
    String txt = '';
    if (CategoryType.all == categoryTypeData) {
      txt = 'All';
    } else if (CategoryType.fic == categoryTypeData) {
      txt = 'Fiction';
    } else if (CategoryType.science == categoryTypeData) {
      txt = 'Science Fiction';
    } else if (CategoryType.astro == categoryTypeData) {
      txt = 'Astrology';
    } else if (CategoryType.tech == categoryTypeData) {
      txt = 'Technology';
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
                categoryType = categoryTypeData;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 12, left: 18, right: 18),
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
            SizedBox(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                      onTap: () {},
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon( Icons.shopping_bag_outlined ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
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

enum CategoryType {
  all,
  fic,
  science,
  astro,
  tech,
}
