import 'package:book_store_application/screens/login/login_screen.dart';
import 'package:book_store_application/screens/sign_up/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'background.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();

}

class _BodyState extends State<Body>{
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 110,),
            SvgPicture.asset("assets/images/image_4.svg",
              height: size.height*0.35,
            ),
            SizedBox(height: 20,),
            const Text('bibliophile',
                style: TextStyle(fontFamily: 'AH-Little Missy', fontSize: 80)
            ),
            const Text('"A room without books is like a body without a soul"',
                style: TextStyle(fontSize: 13)
            ),
            const SizedBox(height: 45),
            FlatButton(
              minWidth: 200,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  side: const BorderSide(color: Colors.black)
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
              onPressed: () {
                Navigator.push( context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
              },
              child: const Text("Login",
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
              ),
            ),
            const SizedBox(height: 10,),
            FlatButton(
              minWidth: 200,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  side: const BorderSide(color: Colors.black)
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SignUpScreen(),
                  ),
                );
              },
              child: const Text("Sign up",
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
              ),
            )
          ],
        )
    );
  }
}


