import 'package:book_store_application/firebase/providers/user_provider.dart';
import 'package:book_store_application/screens/select_card_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'check_out/check_out_screen.dart';

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
        height: 50,
        width: MediaQuery.of(context).size.width / 1.5,
        decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [
              Color.fromRGBO(236, 60, 3, 1),
              Color.fromRGBO(234, 60, 3, 1),
              Color.fromRGBO(216, 78, 16, 1),],
                begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.16),
                offset: Offset(0, 5),
                blurRadius: 10.0,
              )
            ],
            borderRadius: BorderRadius.circular(9.0)),
        child: Center(
          child: Text("Finish",
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontSize: 20.0)
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.grey),
        title: Text(
          'Add Address',
          style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
              fontSize: 18.0),
        ),
      ),
      body: LayoutBuilder(
        builder: (_, viewportConstraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
            BoxConstraints(minHeight: viewportConstraints.maxHeight),
            child: Container(
              padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: MediaQuery.of(context).padding.bottom == 0
                      ? 20
                      : MediaQuery.of(context).padding.bottom),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                SizedBox(
                  child: Form (
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
                                border: InputBorder.none, hintText: 'Flat Number/House Number'),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Colors.white,
                          ),
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
                            InputDecoration(border: InputBorder.none, hintText: 'Street'),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Colors.white,
                          ),
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
                            InputDecoration(border: InputBorder.none, hintText: 'Village'),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Colors.white,
                          ),
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
                            InputDecoration(border: InputBorder.none, hintText: 'District'),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Colors.white,
                          ),
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
                            InputDecoration(border: InputBorder.none, hintText: 'City'),
                          ),
                        ),
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: <Widget>[
                        //     Padding(
                        //       padding: const EdgeInsets.all(16.0),
                        //       child: Text(
                        //         'Area',
                        //         style: TextStyle(fontSize: 12, color: Colors.grey),
                        //       ),
                        //     ),
                        //     ClipRRect(
                        //       borderRadius: BorderRadius.only(
                        //           topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                        //       child: Container(
                        //         padding: EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                        //         decoration: BoxDecoration(
                        //           border: Border(
                        //               bottom: BorderSide(color: Colors.orange, width: 2)),
                        //           color: Colors.orange[100],
                        //         ),
                        //         child: TextField(
                        //           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        //           decoration: InputDecoration(
                        //             border: InputBorder.none,
                        //             hintText: 'Name on card',
                        //             hintStyle:
                        //             TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // Container(
                        //   padding: EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.all(Radius.circular(5)),
                        //     color: Colors.white,
                        //   ),
                        //   child: TextField(
                        //     decoration: InputDecoration(
                        //         border: InputBorder.none, hintText: 'Name on card'),
                        //   ),
                        // ),
                        // ClipRRect(
                        //   borderRadius: BorderRadius.only(
                        //       topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                        //   child: Container(
                        //     padding: EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                        //     decoration: BoxDecoration(
                        //       border: Border(bottom: BorderSide(color: Colors.red, width: 1)),
                        //       color: Colors.white,
                        //     ),
                        //     child: TextField(
                        //       decoration: InputDecoration(
                        //           border: InputBorder.none, hintText: 'Postal code'),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
              )

                ),
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