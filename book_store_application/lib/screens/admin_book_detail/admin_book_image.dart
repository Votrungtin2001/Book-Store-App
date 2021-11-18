import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:book_store_application/constants.dart';
import 'package:book_store_application/firebase/providers/books_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminBookImages extends StatefulWidget {

  Book? book;
  AdminBookImages(Book? BOOK) {
    this.book = BOOK;
  }

  @override
  _AdminBookImagesState createState() => _AdminBookImagesState(this.book);
}

class _AdminBookImagesState extends State<AdminBookImages> {
  int selectedImage = 0;

  Book? book;
  _AdminBookImagesState(Book? BOOK) {
    this.book = BOOK;
  }

  @override
  Widget build(BuildContext context) {
    final booksProvider = Provider.of<BooksProvider>(context);
    int index_book = 0;
    for(int i = 0; i < booksProvider.books.length; i++) {
      if(book!.getID() == booksProvider.books[i].getID()) index_book = i;
    }

    return Column(
      children: [
        SizedBox(
          width: 270,
          child: AspectRatio(
            aspectRatio: 1,
            child: Hero(
              tag: "",
              child: Image.network(booksProvider.books[index_book].getList_IMAGE_URL()[selectedImage], fit: BoxFit.cover),
            ),
          ),
        ),
        // SizedBox(height: getProportionateScreenWidth(20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(booksProvider.books[index_book].getList_IMAGE_URL().length,
                    (index) => buildSmallBookPreview(index, booksProvider.books[index_book])),
          ],
        )
      ],
    );
  }

  GestureDetector buildSmallBookPreview(int index, Book book) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = index;
        });
      },
      child: AnimatedContainer(
        duration: defaultDuration,
        margin: const EdgeInsets.only(right: 15, top: 8),
        padding: const EdgeInsets.all(8),
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: kPrimaryColor.withOpacity(selectedImage == index ? 1 : 0)),
        ),
        child: Image.network(book.getList_IMAGE_URL()[index]),
      ),
    );
  }
}