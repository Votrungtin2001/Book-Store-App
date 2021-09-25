import 'dart:async';
import 'dart:io';

import 'package:book_store_application/MVP/Model/User.dart';
import 'package:book_store_application/firebase/DatabaseManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference users = FirebaseFirestore.instance.collection('Users');
  late Timer timer;


  final googleSignIn = GoogleSignIn(scopes: ['email']);

  final fb = FacebookLogin();

  // create user obj based on firebase user
  User_MD? _userfromFirebase(User user) {
    return user != null ? User_MD(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User_MD?> get user {
    return _auth.authStateChanges().map((User? user) => _userfromFirebase(user!));
  }

  /*// sign in anon
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }*/

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "wrong-password":
          Fluttertoast.showToast(msg: 'Your password is wrong.', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
          break;
        case "user-not-found":
          Fluttertoast.showToast(msg: 'Your email has not been registered . Please register.', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
          break;
        default:
          Fluttertoast.showToast(msg: 'An undefined error happened.', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
      }
    } catch (e) {
      print(e.toString());
    }
  }


  // register with email and password
  Future registerWithEmailAndPassword(String email, String name, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      if(user!=null) {
        await user.sendEmailVerification();
        Fluttertoast.showToast(msg: 'An email has been sent to ${user.email} please verify', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
        int _start = 60;
        const oneSec = const Duration(seconds: 1);
        timer = Timer.periodic(oneSec, (Timer timer) async {
          if(_start == 0) {
            timer.cancel();
            if(user != null) user.delete();
          }
          else {
            _start--;
            checkEmailVerified(name, email, password);
          }

        });
      }
      return user;
    } on SocketException {
      Fluttertoast.showToast(msg: 'No internet, please connect to internet', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: 'This email is already registered. Please enter another email.', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // sign out
  Future signOut() async {
    try {
      if(await googleSignIn.isSignedIn() != null) googleSignIn.disconnect();
      if(await fb.isLoggedIn != null) fb.logOut();
        return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<void> checkEmailVerified(String name, String email, String password) async {
    User? user = _auth.currentUser;
    if (user!=null) await user.reload();
    if(user!= null && user.emailVerified) {
      Fluttertoast.showToast(msg: 'Verify email successfully', toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM);
      timer.cancel();
      User_Model user_model = new User_Model(user.uid, name, 1, "", "", "", "", 0, email, password);
      await DatabaseManager().createUserData(user_model);
    }
  }

  Future signInWithGoogle() async {
    try{
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken
      );

      //Firebase Sign In
      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;

      // Check isNewUser or Not
      if (result.additionalUserInfo!.isNewUser) {
        if (user != null) {
          User_Model user_model = new User_Model(user.uid, user.displayName!, 1, "", "", "", "", 0, user.email!, "");
          await DatabaseManager().createUserData(user_model);
        }

      }
      return user;
    } catch(e) {
      print(e.toString());

    }
  }

  Future loginFacebook() async {
    print('Starting Facebook Login');
    final res = await fb.logIn(
        permissions: [
          FacebookPermission.publicProfile,
          FacebookPermission.email
        ]
    );

    if(res.status == FacebookLoginStatus.success) {
      print('It worked');

      //Get Token
      final FacebookAccessToken? fbToken = res.accessToken;

      //Convert to Auth Credential
      final AuthCredential credential
      = FacebookAuthProvider.credential(fbToken!.token);

      //Firebase Sign In
      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;

      // Check isNewUser or Not
      if (result.additionalUserInfo!.isNewUser) {
        if (user != null) {
          User_Model user_model = new User_Model(user.uid, user.displayName!, 1, "", "", "", "", 0, user.email!, "");
          await DatabaseManager().createUserData(user_model);
        }

      }
      print('${result.user!.displayName} is now logged in');
      return user;
    }
    else if(res.status == FacebookLoginStatus.cancel) {
      print('The user canceled the login');
      Fluttertoast.showToast(msg: 'The user canceled the login.', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
      User? user = null;
      return user;
    }
    else {
      print('There was an error');
      Fluttertoast.showToast(msg: 'There was an error', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
      User? user = null;
      return user;
    }

   /* switch(res.status){
      case FacebookLoginStatus.success:


        break;
      case FacebookLoginStatus.cancel:
        print('The user canceled the login');
        break;
      case FacebookLoginStatus.error:
        print('There was an error');
        break;
    }*/
  }

}
