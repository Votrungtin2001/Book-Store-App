import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final formKey = GlobalKey<FormState>();

  String current_password = "";
  String new_password = "";
  String re_password = "";

  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _rePasswordController = TextEditingController();

  final auth = FirebaseAuth.instance;
  late User user;

  @override
  Widget build(BuildContext context) {
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
            physics: BouncingScrollPhysics(),
            child: Center(
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
                padding: EdgeInsets.only(left: 16.0, right: 16.0,
                    bottom: MediaQuery.of(context).padding.bottom == 0 ? 20 : MediaQuery.of(context).padding.bottom),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  // mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 40,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: SvgPicture.asset("assets/images/Reset password-rafiki.svg",
                        height: MediaQuery.of(context).size.height*0.4,
                      ),
                    ),
                    SizedBox(height: 20,),
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
                                  controller: _currentPasswordController,
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: true,
                                  validator: (value) {
                                    if(value!.isEmpty) {
                                      return "Please enter your current password";
                                    } else return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      current_password = value;
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
                                    hintText: 'Current Password',
                                    prefixIcon: Icon(Icons.lock,color:Colors.black),
                                  ),

                                ),
                              ),
                              const SizedBox(height: 10,),
                              Container(
                                padding: EdgeInsets.only( top: 4.0, bottom: 4.0),
                                child: TextFormField(
                                  controller: _newPasswordController,
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: true,
                                  validator: (value) {
                                    if(value!.length < 6) {
                                      return "Please enter a password which contains more 6 chars";
                                    } else return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      new_password = value;
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
                                    hintText: 'New Password',
                                    prefixIcon: Icon(Icons.lock,color:Colors.black),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Container(
                                padding: EdgeInsets.only( top: 4.0, bottom: 4.0),
                                child: TextFormField(
                                  controller: _rePasswordController,
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: true,
                                  validator: (value) {
                                    if( value! != new_password) {
                                      return "Please check re-enter password and pasword";
                                    } else return null;
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      re_password = value;
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
                                    hintText: 'Re-enter New Password',
                                    prefixIcon: Icon(Icons.lock, color:Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                    SizedBox(height: 30,),
                    Center(
                      child: Row(
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
                              if(formKey.currentState!.validate()) {
                                changePassword(current_password, new_password);
                                _currentPasswordController.clear();
                                _newPasswordController.clear();
                                _rePasswordController.clear();
                              }
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
                      ),
                    )
                  ],
                ),
              ),
            )
        )
    );

  }
  void changePassword(String current_password, String new_password) async {
    user = auth.currentUser!;
    String email = user.email.toString();

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: current_password,
      );

      user.updatePassword(new_password).then((_){
        Fluttertoast.showToast(msg: 'Your password changed successfully', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
        Navigator.of(context).pop();
      }).catchError((error){
        Fluttertoast.showToast(msg: 'Some errors occur. Your password not changed', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
        //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: 'No user found for that email', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: 'Not match with your current password', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
      }
    }
  }
}
