import 'package:book_store_application/MVP/Model/Author.dart';
import 'package:book_store_application/MVP/Model/Book.dart';

abstract class HomeScreenAdminView {
  List<Book> getBookList();
  List<Book> getSuggestionBookList();
  List<Author> getAuthorList();
}