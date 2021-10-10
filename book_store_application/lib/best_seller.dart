import 'dart:core';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import 'MVP/Model/Book.dart';
import 'MVP/Presenter/bestSeller_presenter.dart';
import 'MVP/View/bestSeller_view.dart';
import 'firebase/DatabaseManager.dart';
import 'firebase/providers/books_provider.dart';

class BestSeller extends StatefulWidget {

  @override
  _BestSellerState createState() => _BestSellerState();
}

List<String> images = [
  "assets/images/img_2.png",
  "assets/images/img_2.png",
];

List<String> title = [
  "Hounted Ground",
  "Fallen In Love",
  "The Dreaming Moon",
  "Jack the Persian and the Black Castel",
];

var cardAspectRatio = 12.0 / 16.0;
var widgetAspectRatio = cardAspectRatio * 1.2;

class _BestSellerState extends State<BestSeller>{

  //var currentPage = images.length - 1.0;

  @override
  Widget build(BuildContext context) {
    final booksProvider = Provider.of<BooksProvider>(context);
    var currentPage = booksProvider.books.length - 1.0;
    PageController controller = PageController(initialPage: booksProvider.books.length - 1);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page!;
      });
    });

    return Container(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const <Widget>[
                    Text("Trending",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 26.0,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ),
              Stack(
                children: <Widget>[
                  CardScrollWidget(currentPage, booksProvider.books),
                  Positioned.fill(
                    child: PageView.builder(
                      itemCount: booksProvider.books.length,
                      controller: controller,
                      reverse: true,
                      itemBuilder: (context, index) {
                        return Container();
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20.0,),
            ],
          ),
        ),
      ),
    );
  }

}

class CardScrollWidget extends StatelessWidget {
  var currentPage;
  var padding = 20.0;
  var verticalInset = 20.0;
  List<Book> books = [];

  CardScrollWidget(var CurrentPage, List<Book> list) {
    this.currentPage = CurrentPage;
    books = list;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widgetAspectRatio,
      child: LayoutBuilder(builder: (context, contraints) {

        var width = contraints.maxWidth;
        var height = contraints.maxHeight;

        var safeWidth = width - 2 * padding;
        var safeHeight = height - 2 * padding;

        var heightOfPrimaryCard = safeHeight;
        var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;

        var primaryCardLeft = safeWidth - widthOfPrimaryCard;
        var horizontalInset = primaryCardLeft / 2;

        List<Widget> cardList = [];

        for (var i = 0; i < books.length; i++) {
          var delta = i - currentPage;
          bool isOnRight = delta > 0;

          var start = padding + max(primaryCardLeft - horizontalInset * -delta * (isOnRight ? 15 : 1), 0.0);

          var cardItem = Positioned.directional(
            top: padding + verticalInset * max(-delta, 0.0),
            bottom: padding + verticalInset * max(-delta, 0.0),
            start: start,
            textDirection: TextDirection.rtl,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(3.0, 6.0),
                      blurRadius: 10.0)
                ]),
                child: AspectRatio(
                  aspectRatio: cardAspectRatio,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image.network(
                        books[i].getIMAGE_URL().toString().trim() != ""
                            ? books[i].getIMAGE_URL().toString()
                            : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                        fit: BoxFit.fitWidth,
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Text(books[i].getTITLE(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 25.0,)),
                            ),
                            const SizedBox(height: 10.0,),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0, bottom: 12.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 6.0),
                                decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: const Text("See more", style: TextStyle(color: Colors.white)),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
          cardList.add(cardItem);
        }
        return Stack(
          children: cardList,
        );
      }),
    );
  }
}