import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:book_store_application/MVP/Model/Category.dart';
import 'package:book_store_application/MVP/View/category_admin_view.dart';

class CategoryAdminPresenter {
  late CategoryAdminView view;
  List<Category> categories = [];
  List<Book> booksOfCategory = [];
  List<Book> books = [];

  CategoryAdminPresenter(CategoryAdminView view) {
    this.view = view;
  }

  void getCategoryList() {
    categories = view.getCategoryList();
  }

  void getBookList(){
    books = view.getBookList();
  }

  String getCategoryName(int category_id) {
    for(int i = 0; i < categories.length; i++) {
      if(categories[i].getID() == category_id) return categories[i].getNAME();
    }
    return "";
  }
}