import 'package:book_store_application/MVP/Presenter/accoutAdministration_presenter.dart';
import 'package:book_store_application/MVP/View/accountAdministration_view.dart';
import 'package:book_store_application/firebase/authentication_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'login/login_screen.dart';

class Home_Test extends StatelessWidget implements AccountAdministrationView {

  final AuthenticationServices _auth = AuthenticationServices();
  late AccountAdministrationPresenter presenter;

  Home_Test() {
    this.presenter = new AccountAdministrationPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('Brew Crew'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () {
                presenter.logOut();
                Fluttertoast.showToast(msg: 'Logged out successfully.', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Future<void> logOut() async {
    dynamic result = await _auth.signOut();
  }
}