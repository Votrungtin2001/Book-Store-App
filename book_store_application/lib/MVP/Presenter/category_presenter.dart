import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:book_store_application/MVP/Model/Category.dart';
import 'package:book_store_application/MVP/View/category_view.dart';

class CategoryPresenter {
  late CategoryView view;
  List<Category> categories = [];
  List<Book> booksOfCategory = [];
  List<Book> books = [];

  CategoryPresenter(CategoryView view) {
    this.view = view;
  }

  void getCategoryList() {
    categories = view.getCategoryList();
  }

  void getBookList(){
    books = view.getBookList();
  }
}