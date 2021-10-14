import 'package:book_store_application/MVP/Model/Category.dart';
import 'package:book_store_application/firebase/helpers/category_services.dart';
import 'package:flutter/cupertino.dart';

class CategoryProvider with ChangeNotifier{
  CategoryServices _categoryServices = CategoryServices();
  List<Category> categories = [];

  CategoryProvider.initialize(){
    loadCategories();
  }

  loadCategories()async{
    categories = await _categoryServices.getCategories();
    notifyListeners();
  }
}