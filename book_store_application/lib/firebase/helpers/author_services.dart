import 'package:book_store_application/MVP/Model/Author.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthorServices {
  String collection = "Authors";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Author>> getAuthors() async =>
      _firestore.collection(collection).get().then((result) {
        List<Author> authors = [];
        for (DocumentSnapshot author in result.docs) {
          authors.add(Author.fromSnapshot(author));
        }
        return authors;
      });
}
