import 'package:book_store_application/MVP/View/logIn_view.dart';

class LogInPresenter {
  late LogInView view;

  LogInPresenter(LogInView view) {
    this.view = view;
  }

  void logInWithEmailAndPassword() {
    view.logInWithEmailAndPassword();
  }

  void logInWithGoogle() {
    view.logInWithGoogle();
  }

  void logInWithFacebook() {
    view.logInWithFacebook();
  }
}