import 'package:book_store_application/screens/login/login_screen.dart';
import 'package:book_store_application/screens/sign_up/sign_up_screen.dart';
import 'package:book_store_application/screens/start/components/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';


class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();

}

class _BodyState extends State<Body>{
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
      body: Background(
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
            const Text('MINH THI ĐẸP TRAI',
                style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700)
            ),
            SizedBox(height: 10,),
            const Text('Address: 15/9 đường 19, Linh Chiểu, Thủ Đức',
                style: TextStyle(fontSize: 13)
            ),
            SizedBox(height: 10,),
            const Text('Contact: 012343653',
                style: TextStyle(fontSize: 13)
            ),
          ],
        )
      )
    );
  }
}


