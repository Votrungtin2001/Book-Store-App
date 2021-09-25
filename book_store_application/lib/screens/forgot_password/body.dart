import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}
class _BodyState extends State<Body>{
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     resizeToAvoidBottomInset: true,
     extendBodyBehindAppBar: true,
     appBar: AppBar(
       automaticallyImplyLeading: false,
       elevation: 0,
       backgroundColor: Colors.transparent,
       actions: <Widget>[
         SizedBox(
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
     body: Column(
       mainAxisAlignment: MainAxisAlignment.center,
       crossAxisAlignment: CrossAxisAlignment.center,
       children: <Widget>[
         SvgPicture.asset(
           "assets/images/forgotpassword.svg",height: 240,width: 235,
         ),
         const Text('Are you forgot\npassword',
           style: TextStyle(
               fontSize: 36,
               fontWeight: FontWeight.bold),
         ),
         const Text('Don’t worry! Enter your email below to\nrevice your password reset instructions',
           style: TextStyle(fontSize: 15,
               fontWeight: FontWeight.w300),
         ),
         TextField(
           keyboardType: TextInputType.emailAddress,
           decoration: InputDecoration(
             fillColor: Colors.transparent,
             border: OutlineInputBorder(
               borderRadius: BorderRadius.circular(30.0),
                 borderSide: const BorderSide(
                     color: Colors.black)
             ),
               filled: true,
               hintText: "Email",
               hintStyle: const TextStyle(color: Colors.black38),
               prefixIcon: const Icon(Icons.person, color: Colors.black,)
           ),
         ),
         Row(
           children: [
             FlatButton(
               minWidth: 95,
               shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(20.0),
                   side: const BorderSide(color: Colors.black)
               ),
               padding: const EdgeInsets.symmetric(vertical: 10),
               onPressed: () {},
               child: const Text("Back",
                 style: TextStyle(
                     fontWeight: FontWeight.bold, fontSize: 18),
               ),
             ),
             FlatButton(
               minWidth: 95,
               shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(20.0),
                   side: const BorderSide(color: Colors.black)
               ),
               padding: const EdgeInsets.symmetric(vertical: 10),
               onPressed: () {},
               child: const Text("Next",
                 style: TextStyle(
                     fontWeight: FontWeight.bold, fontSize: 18),
               ),
             ),
           ],
         )
       ],
     )
   );
  }

}