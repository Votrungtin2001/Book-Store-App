
import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:book_store_application/screens/admin_update_book/body.dart';
import 'package:flutter/material.dart';


class UpdateBookScreen extends StatelessWidget {
  Book? book;
  String? category;
  String? author;
  String? publisher;
  UpdateBookScreen(Book? book, String? category, String? author, String? publisher) {
    this.book = book;
    this.category = category;
    this.author = author;
    this.publisher = publisher;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(this.book, this.category, this.author, this.publisher),
    );
  }
}