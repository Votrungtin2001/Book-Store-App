import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

List<String> images = [
  "assets/images/img_2.png",
  "assets/images/img.png",
  "assets/images/bg2.png",
];

class BookImages extends StatefulWidget {

  Book? book;
  BookImages(Book? BOOK) {
    this.book = BOOK;
  }

  @override
  _BookImagesState createState() => _BookImagesState(this.book);
}

class _BookImagesState extends State<BookImages> {
  int selectedImage = 0;

  Book? book;
  _BookImagesState(Book? BOOK) {
    this.book = BOOK;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 270,
          child: AspectRatio(
            aspectRatio: 1,
            child: Hero(
              tag: "",
              child: Image.network(book!.getList_IMAGE_URL()[selectedImage], fit: BoxFit.cover),
            ),
          ),
        ),
        // SizedBox(height: getProportionateScreenWidth(20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(book!.getList_IMAGE_URL().length,
                    (index) => buildSmallBookPreview(index)),
          ],
        )
      ],
    );
  }

  GestureDetector buildSmallBookPreview(int index) {
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
        child: Image.network(book!.getList_IMAGE_URL()[index]),
      ),
    );
  }
}