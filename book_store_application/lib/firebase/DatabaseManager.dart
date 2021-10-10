import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:book_store_application/MVP/Model/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManager {
  final CollectionReference Users =
  FirebaseFirestore.instance.collection('Users');

  final CollectionReference Books = FirebaseFirestore.instance.collection('Books');

  Future<void> createUserData(
      User_Model user_model) async {
    return await Users
        .doc(user_model.id)
        .set({'id': user_model.id, 'name': user_model.name, 'role': user_model.role, 'address': user_model.address,
                'phone': user_model.phone, 'dob': user_model.dob, 'gender': user_model.gender, 'photo': user_model.photo});
  }


  Future getBooksList() async {
    List<Book> books = [];
    try {
      await Books.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {

          int author_id = element.get('author_id');
          int book_id = element.get('book_id');
          int favorite = element.get('favorite');
          int genre_id = element.get('genre_id');
          List<String> image_url = [];
          for(int i = 0; i < 3; i++) {
            if(element.get('image_url')[i].toString().trim() != "") image_url.add(element.get('image_url')[i]);
            else image_url.add("");
          }
          int iPrice = element.get('price');
          double price = iPrice.toDouble();
          int publisher_id = element.get('publisher_id');
          int publishing_year = element.get('publishing_year');
          int quantity = element.get('quantity');
          int sold_count = element.get('sold_count');
          String summary = element.get('summary');
          String title = element.get('title');
          Book book = new Book(book_id, author_id, favorite, genre_id, image_url, price,
          publisher_id, publishing_year, quantity, sold_count, summary, title);
          books.add(book);
        });
      });
      return books;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  /*Future updateUserList(String name, String gender, int score, String uid) async {
    return await profileList.document(uid).updateData({
      'name': name, 'gender': gender, 'score': score
    });
  }

  Future getUsersList() async {
    List itemsList = [];

    try {
      await profileList.getDocuments().then((querySnapshot) {
        querySnapshot.documents.forEach((element) {
          itemsList.add(element.data);
        });
      });
      return itemsList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }*/
}