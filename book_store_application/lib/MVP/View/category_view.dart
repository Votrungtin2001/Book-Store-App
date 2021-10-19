import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:book_store_application/MVP/Model/Category.dart';

abstract class CategoryView {
  List<Category> getCategoryList();
  List<Book> getBookList();
}