import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:book_store_application/firebase/helpers/books_services.dart';
import 'package:flutter/material.dart';

class BooksProvider with ChangeNotifier {
  BooksServices _booksServices = BooksServices();
  List<Book> books = [];
  List<Book> booksOfCategory = [];
  List<Book> bestSellerBooks = [];
  List<Book> sugesstionBooks = [];

  BooksProvider.initialize(){
    loadBooks();
  }

  loadBooks() async {
    books = await _booksServices.getBooks();
    notifyListeners();
  }

  loadSuggestionBooks({int? id})async{
    sugesstionBooks = await _booksServices.getSuggestionBooks();
    notifyListeners();
  }

  loadBooksByCategory({int? id})async{
    if(id == 0) {
      booksOfCategory = await _booksServices.getBooks();
      notifyListeners();
    }
    else {
      booksOfCategory = await _booksServices.getBooksOfCategory(id: id);
      notifyListeners();
    }
  }

  Future loadBestSellerBooks() async {
    List<Book> list1 = await _booksServices.getBooks();
    List<Book> list2 = [];
    if(list1.length >= 5) {
      for (int i = 0; i < list1.length - 1; i++) {
        for (int j = i + 1; j < list1.length; j++) {
          if (list1[i].getSOLD_COUNT() < list1[j].getSOLD_COUNT()) {
            Book book = list1[i];
            list1[i] = list1[j];
            list1[j] = book;
          }
        }
      }
      for (int i = 0; i < 5; i++) {
        list2.add(list1[i]);
      }
    }
    bestSellerBooks = list2;
    notifyListeners();
  }


}
