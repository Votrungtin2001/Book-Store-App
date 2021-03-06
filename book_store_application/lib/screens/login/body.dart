import 'package:book_store_application/MVP/Presenter/logIn_presenter.dart';
import 'package:book_store_application/MVP/View/logIn_view.dart';
import 'package:book_store_application/firebase/authentication_services.dart';
import 'package:book_store_application/home_page.dart';
import 'package:book_store_application/screens/admin_main_page.dart';
import 'package:book_store_application/screens/forgot_password/forgot_password_screen.dart';
import 'package:book_store_application/screens/sign_up/sign_up_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../constants.dart';
import '../../home_page_admin.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> implements LogInView{
  String email = "";
  String password = "";

  final formKey = GlobalKey<FormState>(); //key for form

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final AuthenticationServices _auth = AuthenticationServices();
  String collection = "User";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  late User user;

  late LogInPresenter presenter;

  _BodyState() {
    this.presenter = new LogInPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 36.0, horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const <Widget>[
                        Text('hello again, \nwelcome \nback',
                          style: TextStyle(
                              fontSize: 36, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                    flex: 4,
                    child: Form(
                      key: formKey,
                        child: Container(
                          height: size.height,
                          decoration: const BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              )
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,

                              children: [
                                Container(
                                    alignment: Alignment.center,
                                    child: Column(
                                        children: [
                                          TextFormField(
                                            style: const TextStyle( fontSize: 15,),
                                            controller: _emailController,
                                            keyboardType: TextInputType.emailAddress,
                                            validator: (value) => value != null && !EmailValidator.validate(email)
                                                ? 'Please enter a valid email'
                                                : null,
                                            onChanged: (value) {
                                              setState(() {
                                                email = value;
                                              });
                                            },
                                            decoration: InputDecoration(
                                                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                                                fillColor: Colors.transparent,
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(30.0),
                                                    borderSide: const BorderSide(color: Colors.black)
                                                ),
                                                filled: true,
                                                hintText: "Email",
                                                hintStyle: const TextStyle(color: Colors.black38),
                                                prefixIcon: const Icon(Icons.person, color: Colors.black)
                                            ),
                                          ),
                                          const SizedBox(height: 10,),
                                          TextFormField(
                                            style: const TextStyle( fontSize: 15,),
                                            controller: _passwordController,
                                            keyboardType: TextInputType.visiblePassword,
                                            obscureText: true,
                                            validator: (value) {
                                              if(value!.length < 6) {
                                                return "Please enter a password which contains more 6 chars";
                                              } else return null;
                                            },
                                            onChanged: (value) {
                                              setState(() {
                                                password = value;
                                              });
                                            },
                                            decoration: InputDecoration(
                                                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                                                fillColor: Colors.transparent,
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(30.0),
                                                    borderSide: const BorderSide(color: Colors.black)
                                                ),
                                                filled: true,
                                                hintText: "Password",
                                                hintStyle: const TextStyle(color: Colors.black38),
                                                prefixIcon: const Icon(Icons.lock, color: Colors.black)
                                            ),
                                          ),
                                        ])
                                ),
                                TextButton(
                                  onPressed: () { Navigator.push( context,
                                      MaterialPageRoute(
                                      builder: (context) => ForgotPasswordScreen()
                                    ),
                                  );
                                  },
                                  child: const Text("Forgot a password?",
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.w700,)
                                  ),
                                ),
                                const SizedBox(height: 25.0,),
                                FlatButton(
                                  minWidth: 200,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      side: const BorderSide(color: Colors.black)
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  onPressed: () async {
                                    if(formKey.currentState!.validate()) {{
                                      presenter.logInWithEmailAndPassword();
                                    }}
                                  },
                                  child: const Text("Login",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                ),
                                const SizedBox(height: 15.0,),
                                SizedBox(
                                  child: Row(
                                    children: const <Widget>[
                                      Expanded(
                                        child: Divider(
                                          color: Colors.black,
                                          thickness: 2,
                                        ),
                                      ),
                                      Text(
                                        " Or continue with",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color: Colors.black,
                                          thickness: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15.0,),
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 7),
                                  padding: const EdgeInsets.all(7),
                                  alignment: Alignment.center,
                                  child: Row(
                                    children: <Widget>[
                                      MaterialButton(
                                        onPressed: () async {
                                          presenter.logInWithFacebook();
                                        },
                                        child: Container(
                                            height: 40,
                                            width: 120,
                                            margin: const EdgeInsets.all(5.0),
                                            padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 1,
                                                color: Colors.black,
                                              ),
                                              borderRadius: BorderRadius.circular(80),
                                            ),
                                            child: Row(
                                              children: [
                                                SvgPicture.asset("assets/icons/icons8-facebook.svg"),
                                                const Text("facebook",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w300),
                                                ),
                                              ],
                                            )
                                        ),
                                      ),
                                      MaterialButton(
                                        onPressed: () async {
                                          presenter.logInWithGoogle();
                                        },
                                        child: Container(
                                            height: 40,
                                            width: 120,
                                            padding: const EdgeInsets.only( top: 5.0, bottom: 5.0),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 1,
                                                color: Colors.black,
                                              ),
                                              borderRadius: BorderRadius.circular(80),
                                            ),
                                            child: Row(
                                              children: [
                                                SvgPicture.asset("assets/icons/icons8-google.svg"),
                                                const Text("google",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w300),
                                                ),
                                              ],
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 50,),
                                RichText(
                                    text: TextSpan(
                                      text: 'Don???t have an account?',
                                      children: <TextSpan>[
                                        TextSpan(text: 'Register now',
                                            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                            recognizer: TapGestureRecognizer()..onTap = (){
                                          Navigator.push( context,
                                              MaterialPageRoute(
                                              builder: (context) => SignUpScreen(),
                                              ),
                                          );
                                          },
                                        )
                                      ],
                                    )
                                ),
                              ],
                            ),
                          ),
                        )
                    )
                ),
              ]
          ),
        ),
      ),
    );
  }

  @override
  Future<void> logInWithEmailAndPassword() async {
    dynamic result = await _auth.signInWithEmailAndPassword(email, password);
    if(result != null) {
      user = auth.currentUser!;
      String user_id = await user.uid.toString();
      if(user_id == "nI8SJUbcVcMOnG8bcyk0B5FAzX12") { // tried to find admin with its uid
        Fluttertoast.showToast(msg: 'Logged in successfully.', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePageAdmin()));
      }
      else {
        Fluttertoast.showToast(msg: 'Logged in successfully.', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
      }

    }
  }

  @override
  Future<void> logInWithGoogle() async {
    dynamic result = await _auth.signInWithGoogle();
    if(result != null) {
      Fluttertoast.showToast(msg: 'Logged in successfully.', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  @override
  Future<void> logInWithFacebook() async {
    dynamic result = await _auth.loginFacebook();
    if(result != null) {
      Fluttertoast.showToast(msg: 'Logged in successfully.', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => HomePage()));
    }
  }


}
