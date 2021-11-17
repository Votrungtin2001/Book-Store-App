import 'package:book_store_application/MVP/Presenter/signUp_presenter.dart';
import 'package:book_store_application/MVP/View/signUp_view.dart';
import 'package:book_store_application/firebase/authentication_services.dart';
import 'package:book_store_application/screens/login/login_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../constants.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> implements SignUpView{

  final formKey = GlobalKey<FormState>(); //key for form
  late SignUpPresenter presenter;

  String email = "";
  String name = "";
  String password = "";
  String re_password = "";

  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _repasswordController = TextEditingController();

  final AuthenticationServices _auth = AuthenticationServices();

  _BodyState() {
    this.presenter = new SignUpPresenter(this);
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
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
            maxHeight: MediaQuery
                .of(context)
                .size
                .height,
            maxWidth: MediaQuery
                .of(context)
                .size
                .width,
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
                        Text('hello guys!, \nsignup to \nget started',
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    alignment: Alignment.center,
                                    child: Column(
                                        children: [
                                          TextFormField(
                                            style: const TextStyle( fontSize: 15,),
                                            controller: _emailController,
                                            keyboardType: TextInputType
                                                .emailAddress,
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
                                                    borderRadius: BorderRadius
                                                        .circular(30.0),
                                                    borderSide: const BorderSide(
                                                        color: Colors.black)
                                                ),
                                                filled: true,
                                                hintText: "Email",
                                                hintStyle: const TextStyle(
                                                    color: Colors.black38),
                                                prefixIcon: const Icon(Icons.person,
                                                    color: Colors.black)
                                            ),
                                          ),
                                          const SizedBox(height: 10,),
                                          TextFormField(
                                            style: const TextStyle( fontSize: 15,),
                                            controller: _nameController,
                                            keyboardType: TextInputType
                                                .text,
                                            validator: (value) {
                                              if(value!.isEmpty || !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                                                return "Please enter correct name";
                                              } else return null;
                                            },
                                            onChanged: (value) {
                                              setState(() {
                                                name = value;
                                              });
                                            },
                                            decoration: InputDecoration(
                                                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                                                fillColor: Colors.transparent,
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(30.0),
                                                    borderSide: const BorderSide(
                                                        color: Colors.black)
                                                ),
                                                filled: true,
                                                hintText: "Name",
                                                hintStyle: const TextStyle(
                                                    color: Colors.black38),
                                                prefixIcon: const Icon(
                                                    Icons.account_circle_outlined, color: Colors.black)
                                            ),
                                          ),
                                          const SizedBox(height: 10,),
                                          TextFormField(
                                            style: const TextStyle( fontSize: 15,),
                                            controller: _passwordController,
                                            keyboardType: TextInputType
                                                .visiblePassword,
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
                                                    borderRadius: BorderRadius
                                                        .circular(30.0),
                                                    borderSide: const BorderSide(
                                                        color: Colors.black)
                                                ),
                                                filled: true,
                                                hintText: "Password",
                                                hintStyle: const TextStyle(
                                                    color: Colors.black38),
                                                prefixIcon: const Icon(
                                                    Icons.lock, color: Colors.black)
                                            ),
                                          ),
                                          const SizedBox(height: 10,),
                                          TextFormField(
                                            style: const TextStyle( fontSize: 15,),
                                            controller: _repasswordController,
                                            keyboardType: TextInputType
                                                .visiblePassword,
                                            obscureText: true,
                                            validator: (value) {
                                              if(value! != password) {
                                                return "Please check re-enter password and pasword";
                                              } else return null;
                                            },
                                            onChanged: (value) {
                                              setState(() {
                                                re_password = value;
                                              });
                                            },
                                            decoration: InputDecoration(
                                                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                                                fillColor: Colors.transparent,
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(30.0),
                                                    borderSide: const BorderSide(
                                                        color: Colors.black)
                                                ),
                                                filled: true,
                                                hintText: "Re-enter Password",
                                                hintStyle: const TextStyle(
                                                    color: Colors.black38),
                                                prefixIcon: const Icon(
                                                    Icons.lock, color: Colors.black)
                                            ),
                                          ),
                                          const SizedBox(height: 10,),
                                        ])
                                ),
                                const SizedBox(height: 25.0,),
                                FlatButton(
                                  minWidth: 200,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      side: const BorderSide(color: Colors.black)
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  onPressed: () {
                                    if(formKey.currentState!.validate()) {
                                      presenter.createUser();
                                    }
                                  },
                                  child: const Text("Sign up",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                ),
                                const SizedBox(height: 50,),
                                RichText(
                                    text: TextSpan(
                                      text: 'Already have an account?',
                                      children: <TextSpan>[
                                        TextSpan(text: 'Sign In',
                                          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                          recognizer: TapGestureRecognizer()..onTap = (){
                                            Navigator.push( context,
                                              MaterialPageRoute(
                                                builder: (context) => LoginScreen(),
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

                    ),

                ),
              ]
          ),
        ),
      ),
    );
  }

  @override
  Future<void> createUser() async {
      dynamic result = await _auth.registerWithEmailAndPassword(
          _emailController.text, _nameController.text, _passwordController.text);
      if (result != null) {
        print(result.toString());
        _nameController.clear();
        _passwordController.clear();
        _emailController.clear();
        _repasswordController.clear();
      }
    }
  }
