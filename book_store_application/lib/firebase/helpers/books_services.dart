import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class BooksServices {
  String collection = "Books";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Book>> getBooks() async =>
      _firestore.collection(collection).orderBy('book_id', descending: false).get().then((result) {
        List<Book> books = [];
        for (DocumentSnapshot book in result.docs) {
          books.add(Book.fromSnapshot(book));
        }
        return books;
      });

  Future<List<Book>> getSuggestionBooks() async =>
      _firestore.collection(collection).get().then((result) {
        List<Book> books = [];
        int count = 0;
        for (DocumentSnapshot book in result.docs) {
          count++;
          books.add(Book.fromSnapshot(book));
          if (count > 4) return books;
        }
        return books;
      });

  Future<List<Book>> getBooksOfCategory({int? id}) async =>
      _firestore
          .collection(collection)
          .where("category_id", isEqualTo: id)
          .get()
          .then((result) {
        List<Book> books = [];
        for (DocumentSnapshot book in result.docs) {
          books.add(Book.fromSnapshot(book));
        }
        return books;
      });

  Future<List<Book>> getBooksOfAuthor({int? id}) async =>
      _firestore
          .collection(collection)
          .where("author_id", isEqualTo: id)
          .get()
          .then((result) {
        List<Book> books = [];
        for (DocumentSnapshot book in result.docs) {
          books.add(Book.fromSnapshot(book));
        }
        return books;
      });

  Future<List<Book>> getBooksOfPublisher({int? id}) async =>
      _firestore
          .collection(collection)
          .where("publisher_id", isEqualTo: id)
          .get()
          .then((result) {
        List<Book> books = [];
        for (DocumentSnapshot book in result.docs) {
          books.add(Book.fromSnapshot(book));
        }
        return books;
      });
}
