import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class BooksServices {
  String collection = "Books";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Book>> getBooks() async =>
      _firestore.collection(collection).get().then((result) {
        List<Book> books = [];
        for (DocumentSnapshot book in result.docs) {
          int id = book.get('book_id');
          int author_id = book.get('author_id');
          int favorite = book.get('favorite');
          int genre_id = book.get('genre_id');
          List<String> image_url = [];
          for(int i = 0; i < 3; i++) {
            if(book.get('image_url')[i].toString().trim() != "") image_url.add(book.get('image_url')[i]);
            else image_url.add("");
          }
          int iPrice = book.get('price');
          double price = iPrice.toDouble();
          int publisher_id = book.get('publisher_id');
          int publishing_year = book.get('publishing_year');
          int quantity = book.get('quantity');
          int sold_count = book.get('sold_count');
          String title = book.get('title');
          String summary = book.get('summary');
          Book i = new Book(id, author_id, favorite, genre_id, image_url, price, publisher_id,
              publishing_year, quantity, sold_count, summary, title);
          books.add(i);
        }
        return books;
      });
}
