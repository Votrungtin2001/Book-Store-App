import 'package:book_store_application/MVP/Presenter/forgotPassword_presenter.dart';
import 'package:book_store_application/MVP/View/forgotPassword_view.dart';
import 'package:book_store_application/firebase/authentication_services.dart';
import 'package:book_store_application/screens/login/login_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> implements ForgotPasswordView{
  final formKey = GlobalKey<FormState>(); //key for form
  String email = "";

  TextEditingController _emailController = TextEditingController();
  final AuthenticationServices _auth = AuthenticationServices();

  late ForgotPasswordPresenter presenter;

  _BodyState() {
    this.presenter = new ForgotPasswordPresenter(this);
  }


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
     body: Stack(
       children: <Widget>[
         InkWell(
           child: SingleChildScrollView(
             child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: <Widget>[
               SizedBox(height: 120,),
               SvgPicture.asset("assets/images/forgotpassword.svg",height: 240,width: 235,),
               SizedBox(height: 10,),
               const Text('Are you forgot\npassword',
                 textAlign: TextAlign.center,
                 style: TextStyle(
                     fontSize: 36,
                     fontWeight: FontWeight.bold),
         ),
               const Text('Don???t worry! Enter your email below to\nrevice your password reset instructions',
                 textAlign: TextAlign.center,
                 style: TextStyle(fontSize: 15,
                     fontWeight: FontWeight.w300),
         ),
               SizedBox(height: 30,),
               Form(
                 key: formKey,
                 child: Container(
                   width: 300,
                   child: TextFormField(
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
                     style: const TextStyle( fontSize: 15,),
                     decoration: InputDecoration(
                         contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
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
                 ),
               ),

               SizedBox(height: 45,),
               Row(
           mainAxisAlignment: MainAxisAlignment.center,
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
             SizedBox(width: 40,),
             FlatButton(
               minWidth: 95,
               shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(20.0),
                   side: const BorderSide(color: Colors.black)
               ),
               padding: const EdgeInsets.symmetric(vertical: 10),
               onPressed: () {
                 if(formKey.currentState!.validate()) {
                   presenter.sendEmailResetPassword(email);

               }},
               child: const Text("Next",
                 style: TextStyle(
                     fontWeight: FontWeight.bold, fontSize: 18),
               ),
             ),
           ],
         )
             ],
           ),
           ),
         )
       ],
     )
   );
  }

  @override
  Future<void> sendEmailResetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => LoginScreen()));
    Fluttertoast.showToast(msg: 'A password reset link has been sent to ${email}', toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM);
  }

}