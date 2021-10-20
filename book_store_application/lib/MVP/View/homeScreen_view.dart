import 'package:book_store_application/MVP/Model/Author.dart';
import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:book_store_application/MVP/Model/Category.dart';

abstract class HomeScreenView {
  List<Book> getBookList();
  List<Book> getSuggestionBookList();
  List<Author> getAuthorList();
}
