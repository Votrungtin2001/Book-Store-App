import 'package:book_store_application/MVP/Model/Author.dart';
import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:book_store_application/MVP/Model/Category.dart';
import 'package:book_store_application/MVP/View/homeScreen_view.dart';

class HomeScreenPresenter {
  late HomeScreenView view;
  List<Category> categories = [];
  List<Book> books = [];
  List<Author> authors = [];

  HomeScreenPresenter(HomeScreenView view) {
    this.view = view;
  }

  void getCategoryList() {
    categories = view.getCategoryList();
  }

  void getBookList(){
    books = view.getBookList();
  }

  List<Book> getBooksOfCategory(int category_id) {
    List<Book> booksOfCategory = [];
    for(int i = 0; i < books.length; i++) {
      if(books[i].getCATEGORY_ID() == category_id) {
        booksOfCategory.add(books[i]);
      }
    }
    return booksOfCategory;
  }

}