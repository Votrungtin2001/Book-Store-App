import 'package:book_store_application/MVP/Model/Author.dart';
import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:book_store_application/MVP/Model/Category.dart';
import 'package:book_store_application/MVP/View/homeScreen_view.dart';

class HomeScreenPresenter {
  late HomeScreenView view;
  List<Category> categories = [];
  List<Book> books = [];
  List<Book> suggestionBook = [];
  List<Author> authors = [];

  HomeScreenPresenter(HomeScreenView view) {
    this.view = view;
  }

  void getBookList(){
    books = view.getBookList();
  }
  void getSuggestionBookList(){
    suggestionBook = view.getSuggestionBookList();
  }
  void getAuthorList() {
    authors = view.getAuthorList();
  }

}
