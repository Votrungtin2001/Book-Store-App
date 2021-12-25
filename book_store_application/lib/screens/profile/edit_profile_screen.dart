import 'dart:io';

import 'package:book_store_application/firebase/providers/user_provider.dart';
import 'package:book_store_application/screens/profile/profile_ava.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final formKey = GlobalKey<FormState>();
  String name = "";
  String phone = "";
  String address = "";
  String selectedPhoto = "";

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  bool showPassword = false;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String collection = "Users";


  File? image;
  String? filename;
  late String user_id;
  late String url;

  Future _getImage() async{
    try{
      final image = await ImagePicker().pickImage(
          source: ImageSource.gallery
      );
      final imageTemporaty = File(image!.path);
      setState(() {
        this.image = imageTemporaty;
        this.filename = basename(image.path);
        selectedPhoto = basename(image.path);
      }) ;
    }
    on PlatformException catch(e){
      print('Failed o pick image: $e');
    }

  }
  @override
  Widget build(BuildContext context) {
    final user_model = Provider.of<UserProvider>(context);
    String photo = user_model.user.getPhoto();
    user_id = user_model.user.getID();
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      //   elevation: 1,
      //   leading: IconButton(
      //     icon: Icon(
      //       Icons.arrow_back,
      //       color: Colors.green,
      //     ),
      //     onPressed: () {},
      //   ),
      //   actions: [
      //     IconButton(
      //       icon: Icon(
      //         Icons.settings,
      //         color: Colors.green,
      //       ),
      //       onPressed: () {
      //         Navigator.of(context).push(MaterialPageRoute(
      //             builder: (BuildContext context) => SettingsPage()));
      //       },
      //     ),
      //   ],
      // ),
        body: Container(
          padding: EdgeInsets.only(left: 16, top: 25, right: 16),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 15,),
                  SizedBox(
                    height: 115,
                    width: 115,
                    child: Stack(
                      fit: StackFit.expand,
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          backgroundImage: image!= null ? Image.file(image!, fit:BoxFit.cover).image
                              : Image.network(photo, fit: BoxFit.cover).image,
                        ),
                        Positioned(
                          right: -16,
                          bottom: 0,
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  side: const BorderSide(color: Colors.white),
                                ),
                                primary: Colors.white,
                                backgroundColor: Color(0xFFF5F6F9),
                              ),
                              onPressed: () {
                                _getImage();
                              },
                              child: const Icon( Icons.camera_alt, color: Colors.black,),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50,),
                  SizedBox(
                    child: Form(
                      key: formKey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("   Full name",style: TextStyle(color:Colors.black,fontSize: 17),),
                            Container(
                              padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                              child: TextFormField(
                                controller: _nameController,
                                onChanged: (value) {
                                  setState(() {
                                    name = value;
                                  });
                                },
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
                                    fillColor: Colors.transparent,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                        borderSide: const BorderSide(color: Colors.black)
                                    ),
                                    filled: true,
                                    hintStyle: const TextStyle(color: Colors.black38),
                                    prefixIcon: Icon(Icons.person,color:Colors.black),
                                    hintText: user_model.user.getName()
                                ),
                              ),
                            ),
                            const SizedBox(height: 15,),
                            Text("   Phone number",style: TextStyle(color:Colors.black,fontSize: 17),),
                            Container(
                              padding: EdgeInsets.only( top: 4.0, bottom: 4.0),
                              child: TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    phone = value;
                                  });
                                },
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10),
                                    fillColor: Colors.transparent,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                        borderSide: const BorderSide(color: Colors.black)
                                    ),
                                    filled: true,
                                    hintStyle: const TextStyle(color: Colors.black38),
                                    prefixIcon: Icon(Icons.phone,color:Colors.black),
                                    hintText: user_model.user.getPhone()
                                ),
                              ),
                            ),
                            const SizedBox(height: 15,),
                            Text("   Address",style: TextStyle(color:Colors.black,fontSize: 17),),
                            Container(
                              padding: EdgeInsets.only( top: 4.0, bottom: 4.0),
                              child: TextFormField(
                                controller: _addressController,
                                onChanged: (value) {
                                  setState(() {
                                    address = value;
                                  });
                                },
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
                                    fillColor: Colors.transparent,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                        borderSide: const BorderSide(color: Colors.black)
                                    ),
                                    filled: true,
                                    hintStyle: const TextStyle(color: Colors.black38),
                                    prefixIcon: Icon(Icons.edit_location,color:Colors.black),
                                    hintText: user_model.user.getAddress()),
                              ),
                            ),

                          ]
                      ),
                    ),
                  ),
                  const SizedBox(height: 35,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlineButton(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () {Navigator.of(context).pop();},
                        child: Text("CANCEL",
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 2.2,
                                color: Colors.black)),
                      ),
                      RaisedButton(
                        onPressed: () {
                          // Store image in storage
                          if(selectedPhoto != "") {
                            firebase_storage.FirebaseStorage storage =
                                firebase_storage.FirebaseStorage.instance;
                            firebase_storage.Reference ref = storage.ref().child(filename!);
                            firebase_storage.UploadTask uploadTask = ref.putFile(image!);
                            uploadTask.whenComplete(() async {
                              url = await ref.getDownloadURL();
                              if(url != "") {
                                //Save image in firestore
                                _firestore.collection(collection).doc(user_id).update({'photo': url});
                                user_model.updatePhoto(url);
                              }
                            });
                          }
                          ////
                          if(name != "") {
                            _firestore.collection(collection).doc(user_model.user.getID()).update({'name': name});
                            user_model.user.setName(name);

                          }
                          if(phone != "") {
                            _firestore.collection(collection).doc(user_model.user.getID()).update({'phone': phone});
                            user_model.user.setPhone(phone);

                          }
                          if(address != "") {
                            _firestore.collection(collection).doc(user_model.user.getID()).update({'address': address});
                            user_model.user.setAddress(address);

                          }
                          _nameController.text = "";
                          _phoneController.text = "";
                          _addressController.text = "";

                          Fluttertoast.showToast(msg: 'Updated your information successfully', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
                          Navigator.of(context).pop();
                        },
                        color: Colors.blue,
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          "SAVE",
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 2.2,
                              color: Colors.white),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}