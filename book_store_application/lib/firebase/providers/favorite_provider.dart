import 'package:book_store_application/MVP/Model/Favorite.dart';
import 'package:book_store_application/MVP/Model/Publisher.dart';
import 'package:book_store_application/firebase/helpers/favorite_services.dart';
import 'package:flutter/cupertino.dart';

class FavoriteProvider with ChangeNotifier{
  FavoriteServices _favoriteServices = FavoriteServices();
  List<Favorite> favorites = [];

  FavoriteProvider.initialize(){
    loadFavorites();
  }

  loadFavorites()async{
    favorites = await _favoriteServices.getFavorites();
    notifyListeners();
  }
}