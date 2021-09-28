
import 'package:book_store_application/MVP/View/forgotPassword_view.dart';

class ForgotPasswordPresenter {
  late ForgotPasswordView view;

  ForgotPasswordPresenter(ForgotPasswordView view) {
    this.view = view;
  }

  void sendEmailResetPassword(String email) {
    view.sendEmailResetPassword(email);
  }
}