import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:flutter/material.dart';
import 'package:book_store_application/screens/book_detail/body.dart';

class BookDetailScreen extends StatelessWidget {
  Book? book;
  BookDetailScreen(Book? book) {
    this.book = book;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(this.book),
    );
  }
}
