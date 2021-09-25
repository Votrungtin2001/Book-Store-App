import 'package:book_store_application/MVP/Model/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManager {
  final CollectionReference Users =
  FirebaseFirestore.instance.collection('Users');

  Future<void> createUserData(
      User_Model user_model) async {
    return await Users
        .doc(user_model.id)
        .set({'id': user_model.id, 'name': user_model.name, 'role': user_model.role, 'address': user_model.address,
                'phone': user_model.phone, 'dob': user_model.dob, 'gender': user_model.gender, 'photo': user_model.photo,
                  'email': user_model.email, 'password': user_model.password});
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