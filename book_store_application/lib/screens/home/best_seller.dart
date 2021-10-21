import 'dart:core';
import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:book_store_application/firebase/providers/books_provider.dart';
import 'package:book_store_application/screens/book_detail/book_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'dart:math';


class BestSeller extends StatefulWidget {
  @override
  _BestSellerState createState() => _BestSellerState();
}

var cardAspectRatio = 12.0 / 16.0;
var widgetAspectRatio = cardAspectRatio * 1.2;

class _BestSellerState extends State<BestSeller>{

  var currentPage = 5 - 1.0;

  @override
  Widget build(BuildContext context) {
    final booksProvider = Provider.of<BooksProvider>(context);
    booksProvider.loadBestSellerBooks();

    PageController controller = PageController(initialPage: 5 - 1);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page!;
      });
    });

    return Container(
      color: Colors.transparent,
     // child: Scaffold(
       // backgroundColor: Colors.transparent,
        child: SingleChildScrollView(
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
                          fontWeight: FontWeight.w800,
                        )
                    ),
                  ],
                ),
              ),
              Stack(
                children: <Widget>[
                  CardScrollWidget(currentPage,booksProvider.bestSellerBooks),
                  Positioned.fill(
                    child: PageView.builder(
                      itemCount: booksProvider.bestSellerBooks.length,
                      controller: controller,
                      reverse: true,
                      itemBuilder: (context, index) {
                        return Container();
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      //),
    );
  }
}

class CardScrollWidget extends StatelessWidget {
  var currentPage;
  var padding = 10.0;
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

        for (var i = 0; i < books.length ; i++) {
          var delta = i - currentPage;
          bool isOnRight = delta > 0;

          var start = padding + max(primaryCardLeft - horizontalInset * -delta * (isOnRight ? 15 : 1), 0.0);

          var cardItem = Positioned.directional(
            top: padding + verticalInset * max(-delta, 0.0),
            bottom: padding + verticalInset * max(-delta, 0.0),
            start: start,
            textDirection: TextDirection.rtl,
            child: InkWell(
                onTap: () => Navigator.push<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => BookDetailScreen(books[i]),
                  ),
                ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
                child: Container(
                  decoration: const BoxDecoration(color: Colors.white,
                      boxShadow: [
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
                        InkWell(
                          onTap: () { Navigator.push<dynamic>(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) => BookDetailScreen(books[i]),
                            ),
                          );
                          },
                          child: Image.network(
                            books[i].getIMAGE_URL().toString().trim() != ""
                                ? books[i].getIMAGE_URL().toString()
                                : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                child: Text(books[i].getTITLE(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 25.0,)),
                              ),
                              const SizedBox(height: 10.0,),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ),
          );

          cardList.add(cardItem);
        }

        return Stack(
          children:cardList ,
        );
      }
      ),

    );
  }

}