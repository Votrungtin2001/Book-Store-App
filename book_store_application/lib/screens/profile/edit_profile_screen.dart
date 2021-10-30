import 'package:book_store_application/firebase/providers/user_provider.dart';
import 'package:book_store_application/screens/profile/profile_ava.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

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

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
    bool showPassword = false;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String collection = "Users";

    @override
    Widget build(BuildContext context) {
      final user_model = Provider.of<UserProvider>(context);
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
                ProfileAvatar(),
                SizedBox(
                  child: Form(
                    key: formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                    Container(
                    padding: EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller: _nameController,
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: user_model.user.getName()),
                    ),
                  ),
                          Container(
                            padding: EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              color: Colors.white,
                            ),
                            child: TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  phone = value;
                                });
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none, hintText: user_model.user.getPhone()),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              color: Colors.white,
                            ),
                            child: TextFormField(
                              controller: _addressController,
                              onChanged: (value) {
                                setState(() {
                                  address = value;
                                });
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none, hintText: user_model.user.getAddress()),
                            ),
                          ),
                ]),
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

    Widget buildTextField(String labelText, String placeholder) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 35.0),
        child: TextField(

          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(bottom: 3),
              labelText: labelText,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: placeholder,
              hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              )),
        ),
      );
    }
  }