
import 'package:book_store_application/MVP/View/signUp_view.dart';

class SignUpPresenter {
  late SignUpView view;

  SignUpPresenter(SignUpView view) {
    this.view = view;
  }

  void createUser() {
    view.createUser();
  }
}