import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:book_store_application/firebase/helpers/books_services.dart';
import 'package:flutter/material.dart';

class BooksProvider with ChangeNotifier {
  BooksServices _booksServices = BooksServices();
  List<Book> books = [];

  BooksProvider.initialize(){
    loadBooks();
  }

  loadBooks() async {
    books = await _booksServices.getBooks();
    notifyListeners();
  }
}
