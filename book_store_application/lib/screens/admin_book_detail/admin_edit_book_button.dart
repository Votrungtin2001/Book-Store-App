
import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:book_store_application/screens/admin_update_book/update_book_screen.dart';
import 'package:flutter/material.dart';

class AdminEditBookButton extends StatefulWidget {

  Book? book;
  String? category;
  String? author;
  String? publisher;
  AdminEditBookButton(Book? book, String? category, String? author, String? publisher) {
    this.book = book;
    this.category = category;
    this.author = author;
    this.publisher = publisher;
  }

  @override
  _AdminEditBookButtonState createState() => _AdminEditBookButtonState(this.book, this.category, this.author, this.publisher);
}
class _AdminEditBookButtonState extends State<AdminEditBookButton> with TickerProviderStateMixin {


  Book? book;
  String? category;
  String? author;
  String? publisher;

  _AdminEditBookButtonState(Book? book, String? category, String? author, String? publisher) {
    this.book = book;
    this.category = category;
    this.author = author;
    this.publisher = publisher;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {

            },
          ),
          const SizedBox(width: 10),
          Text("0"),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {

            },
          ),
          Spacer(),
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              primary: Colors.white,
              backgroundColor: Colors.blue,
            ),
            onPressed: () {
              Navigator.push<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => UpdateBookScreen(book, category, author, publisher),
              ));
            },
            child: const Text(
              "Edit Book",
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
