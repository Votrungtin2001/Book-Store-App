import 'package:book_store_application/MVP/Model/Author.dart';
import 'package:book_store_application/firebase/helpers/author_services.dart';
import 'package:flutter/cupertino.dart';

class AuthorProvider with ChangeNotifier{
  AuthorServices _authorServices = AuthorServices();
  List<Author> authors = [];

  AuthorProvider.initialize(){
    loadAuthors();
  }

  loadAuthors()async{
    authors = await _authorServices.getAuthors();
    notifyListeners();
  }
}