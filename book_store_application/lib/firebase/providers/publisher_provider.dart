import 'package:book_store_application/MVP/Model/Publisher.dart';
import 'package:book_store_application/firebase/helpers/publisher_services.dart';
import 'package:flutter/material.dart';

class PublisherProvider with ChangeNotifier{
  PublisherServices _authorServices = PublisherServices();
  List<Publisher> publishers = [];

  PublisherProvider.initialize(){
    loadPublishers();
  }

  loadPublishers()async{
    publishers = await _authorServices.getPublishers();
    notifyListeners();
  }
}