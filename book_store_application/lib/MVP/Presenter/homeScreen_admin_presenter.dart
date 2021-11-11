import 'package:book_store_application/MVP/Model/Author.dart';
import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:book_store_application/MVP/Model/Category.dart';
import 'package:book_store_application/MVP/View/homeScreen_admin_view.dart';

class HomeScreenAdminPresenter {
  late HomeScreenAdminView view;
  List<Category> categories = [];
  List<Book> books = [];
  List<Book> suggestionBook = [];
  List<Author> authors = [];

  HomeScreenAdminPresenter(HomeScreenAdminView view) {
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