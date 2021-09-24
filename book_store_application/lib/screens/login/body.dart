import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body>{
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
                                      TextField(
                                        keyboardType: TextInputType
                                            .emailAddress,
                                        decoration: InputDecoration(
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
                                      TextField(
                                        keyboardType: TextInputType
                                            .visiblePassword,
                                        decoration: InputDecoration(
                                            fillColor: Colors.transparent,
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius
                                                    .circular(30.0),
                                                borderSide: const BorderSide(
                                                    color: Colors.black)
                                            ),
                                            filled: true,
                                            hintText: "Password",
                                            hintStyle: TextStyle(
                                                color: Colors.black38),
                                            prefixIcon: Icon(
                                                Icons.lock, color: Colors.black)
                                        ),
                                      ),
                                    ])
                            ),
                            const SizedBox(height: 5.0,),
                            Container(
                              alignment: Alignment.centerRight,
                              child: const Text("Forgot a password?",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w700)),
                            ),
                            const SizedBox(height: 25.0,),
                            FlatButton(
                              minWidth: 200,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  side: const BorderSide(color: Colors.black)
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              onPressed: () {},
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
                                    onPressed: () async {},
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
                                  const SizedBox(width: 5,),
                                  MaterialButton(
                                    onPressed: () async {},
                                    child: Container(
                                        height: 40,
                                        width: 120,
                                        margin: const EdgeInsets.all(5.0),
                                        padding: const EdgeInsets.only( top: 5.0, bottom: 5.0),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 1,
                                            color: Colors.black,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              80),
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
                            Container(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text('Don’t have an account?'),
                                  Text('Register now',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                ),
              ]
          ),
        ),
      ),
    );
  }
}
