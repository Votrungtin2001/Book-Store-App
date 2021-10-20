import 'package:book_store_application/MVP/Model/Favorite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteServices {
  String collection = "Favorites";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Favorite>> getFavorites() async =>
      _firestore.collection(collection).get().then((result) {
        List<Favorite> favorites = [];
        for (DocumentSnapshot favorite in result.docs) {
          favorites.add(Favorite.fromSnapshot(favorite));
        }
        return favorites;
      });
}