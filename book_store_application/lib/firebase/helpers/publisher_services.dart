import 'package:book_store_application/MVP/Model/Publisher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PublisherServices {
  String collection = "Publishers";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Publisher>> getPublishers() async =>
      _firestore.collection(collection).get().then((result) {
        List<Publisher> publishers = [];
        for (DocumentSnapshot author in result.docs) {
          publishers.add(Publisher.fromSnapshot(author));
        }
        return publishers;
      });
}