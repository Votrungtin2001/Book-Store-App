import 'package:book_store_application/firebase/providers/user_provider.dart';
import 'package:book_store_application/screens/select_card_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'check_out_screen.dart';

class AddPhoneScreen extends StatefulWidget {

  @override
  _AddPhoneScreenState createState() => _AddPhoneScreenState();
}

class _AddPhoneScreenState extends State<AddPhoneScreen> {

  final formKey = GlobalKey<FormState>();

  String phone = "";

  TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user_model = Provider.of<UserProvider>(context);

    Widget finishButton = InkWell(
      onTap:() {
        if(formKey.currentState!.validate()) {{
          user_model.updatePhoneNumber(user_model.user.getID(), phone);
          Navigator.pop(context);
        }}},
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width / 2,
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
            borderRadius: BorderRadius.circular(30.0)),
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
              padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: MediaQuery.of(context).padding.bottom == 0
                      ? 20
                      : MediaQuery.of(context).padding.bottom),
              child: Column(
              //  mainAxisAlignment: MainAxisAlignment.spaceAround,
              //  mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                      child: Form (
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: _phoneController,
                                validator: (value) {
                                  if(value == "") {
                                    return "Please enter your phone number";
                                  } else return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    phone = value;
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
                                    prefixIcon: Icon(Icons.phone),
                                    hintText: 'Phone number'),
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