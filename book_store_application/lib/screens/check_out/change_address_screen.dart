import 'package:book_store_application/firebase/providers/user_provider.dart';
import 'package:book_store_application/screens/select_card_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'check_out_screen.dart';

class AddAddressScreen extends StatefulWidget {

  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {

  final formKey = GlobalKey<FormState>();

  String flat = "";
  String street = "";
  String village = "";
  String district = "";
  String city = "";

  TextEditingController _flatController = TextEditingController();
  TextEditingController _streetController = TextEditingController();
  TextEditingController _villageController = TextEditingController();
  TextEditingController _districtController = TextEditingController();
  TextEditingController _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user_model = Provider.of<UserProvider>(context);

    Widget finishButton = InkWell(
      onTap:() {
        if(formKey.currentState!.validate()) {{
          String address = flat + ", " + street + " Street, " + village + ", " + district + ", " + city;
          user_model.updateAddress(user_model.user.getID(), address);

          Navigator.pop(context);
      }}},
      child: Container(
        height: 45,
        width: MediaQuery.of(context).size.width / 2,
        decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(30.0)),
        child: Center(
          child: Text("FINISH",
              style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 2.2,
                  color: Colors.white)),
        ),
      ),
    );

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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  child: Row(
                    children: const [
                      Icon(Icons.navigate_before, color: Colors.black, size: 35,),
                      Text("Back",
                        style: TextStyle(color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w400),)
                    ],
                  ),
                  onPressed: () { Navigator.pop(context);},
                ),
              ],
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (_, viewportConstraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
            BoxConstraints(minHeight: viewportConstraints.maxHeight),
            child: Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0,
                  bottom: MediaQuery.of(context).padding.bottom == 0
                      ? 20
                      : MediaQuery.of(context).padding.bottom),
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
                  SizedBox(height: 80,),
                SizedBox(
                  child: Form (
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only( top: 4.0, bottom: 4.0),
                          child: TextFormField(
                            controller: _flatController,
                            validator: (value) {
                              if(value == "") {
                                return "Please enter your flat number";
                              } else return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                flat = value;
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
                                prefixIcon: Icon(Icons.house,color: Colors.black,),
                                hintText: 'Flat Number/House Number'),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          padding: EdgeInsets.only( top: 4.0, bottom: 4.0),
                          child: TextFormField(
                            controller: _streetController,
                            validator: (value) {
                              if(value == "") {
                                return "Please enter your street address";
                              } else return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                street = value;
                              });
                            },
                            decoration:
                            InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
                                fillColor: Colors.transparent,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: const BorderSide(color: Colors.black)
                                ),
                                filled: true,
                                hintStyle: const TextStyle(color: Colors.black38),
                                prefixIcon: Icon(Icons.cabin_sharp,color: Colors.black,),
                                hintText: 'Street'),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          padding: EdgeInsets.only( top: 4.0, bottom: 4.0),
                          child: TextFormField(
                            controller: _villageController,
                            validator: (value) {
                              if(value == "") {
                                return "Please enter your village";
                              } else return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                village = value;
                              });
                            },
                            decoration:
                            InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
                                fillColor: Colors.transparent,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: const BorderSide(color: Colors.black)
                                ),
                                filled: true,
                                hintStyle: const TextStyle(color: Colors.black38),
                                prefixIcon: Icon(Icons.location_city,color: Colors.black,),
                                hintText: 'Village'),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          padding: EdgeInsets.only( top: 4.0, bottom: 4.0),
                          child: TextFormField(
                            controller: _districtController,
                            validator: (value) {
                              if(value == "") {
                                return "Please enter your district";
                              } else return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                district = value;
                              });
                            },
                            decoration:
                            InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
                                fillColor: Colors.transparent,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: const BorderSide(color: Colors.black)
                                ),
                                filled: true,
                                hintStyle: const TextStyle(color: Colors.black38),
                                prefixIcon: Icon(Icons.place,color: Colors.black,),
                                hintText: 'District'),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          padding: EdgeInsets.only( top: 4.0, bottom: 4.0),

                          child: TextFormField(
                            controller: _cityController,
                            validator: (value) {
                              if(value == "") {
                                return "Please enter your city";
                              } else return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                city = value;
                              });
                            },
                            decoration:
                            InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
                                fillColor: Colors.transparent,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: const BorderSide(color: Colors.black)
                                ),
                                filled: true,
                                hintStyle: const TextStyle(color: Colors.black38),
                                prefixIcon: Icon(Icons.apartment_rounded,color: Colors.black,),
                                hintText: 'City'),
                          ),
                        ),
                      ],
                    ),
                  )
                ),
                  SizedBox(height: 40,),
                  Center(child: finishButton)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}