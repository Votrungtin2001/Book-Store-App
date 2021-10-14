import 'package:book_store_application/MVP/Model/Category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryServices {
  String collection = "Categories";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Category>> getCategories() async =>
      _firestore.collection(collection).get().then((result) {
        List<Category> categories = [];
        for(DocumentSnapshot category in result.docs){
          categories.add(Category.fromSnapshot(category));
        }
        return categories;
      });
}