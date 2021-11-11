import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:book_store_application/MVP/Model/Category.dart';

abstract class CategoryAdminView {
  List<Category> getCategoryList();
  List<Book> getBookList();
}