import 'package:book_store_application/screens/login/login_screen.dart';
import 'package:book_store_application/screens/sign_up/sign_up_screen.dart';
import 'package:book_store_application/screens/start/components/background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();

}

class _BodyState extends State<Body>{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String collection = "Information";

  final formKey = GlobalKey<FormState>();
  String owner = "";
  String hint_owner = "";
  TextEditingController _ownerController = TextEditingController();

  String address = "";
  String hint_address = "";
  TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    getOwnerName();
    getAddress();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: Row(
                      children: const [
                        Icon(
                          Icons.navigate_before, color: Colors.black, size: 35,),
                        Text("Back", style: TextStyle(color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w400),)
                      ],
                    ),
                    onPressed: () { Navigator.pop(context);},
                  )
                ],
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height,
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/bg2.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 135,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: SvgPicture.asset("assets/images/aboutus.svg",
                        height: size.height*0.35,
                      ),
                    ),
                    SizedBox(height: 20,),
                    const Text('bibliophile',
                        style: TextStyle(fontFamily: 'AH-Little Missy', fontSize: 80)
                    ),
                    SizedBox(height: 10,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Form(
                        key: formKey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only( top: 4.0, bottom: 4.0),
                                child: TextFormField(
                                  controller: _ownerController,
                                  onChanged: (value) {
                                    setState(() {
                                      owner = value;
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
                                    prefixIcon: const Icon(Icons.person, color: Colors.black),
                                    hintText: hint_owner,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10,),
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
                                    prefixIcon: Icon(Icons.edit_location, color: Colors.black,),
                                    hintText: hint_address,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RaisedButton(
                                    onPressed: () {
                                      if(owner != "") {
                                        _firestore.collection(collection).doc('Bibliophile').update({'owner': owner});
                                        setState(() {
                                          hint_owner = owner;
                                          owner = "";
                                        });
                                      }
                                      if(address != "") {
                                        _firestore.collection(collection).doc('Bibliophile').update({'address': address});
                                        setState(() {
                                          hint_address = address;
                                          address = "";
                                        });
                                      }

                                      _ownerController.text = "";
                                      _addressController.text = "";
                                      Fluttertoast.showToast(msg: "Updated Bibliophile's information successfully", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
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

                            ]
                        ),
                      ),
                    ),
                  ],
                )
            )
        )
    );
  }

  Future<void> getOwnerName() async {
    await _firestore.collection(collection).doc('Bibliophile').get().then((result) {
      if(result.exists) {
        setState(() {
          hint_owner = result.get('owner');
        });
      }

    });
  }

  Future<void> getAddress() async {
    await _firestore.collection(collection).doc('Bibliophile').get().then((result) {
      if(result.exists) {
        setState(() {
          hint_address = result.get('address');
        });
      }
    });
  }
}

