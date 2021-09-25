import 'package:book_store_application/MVP/View/accountAdministration_view.dart';

class AccountAdministrationPresenter {
  late AccountAdministrationView view;

  AccountAdministrationPresenter(AccountAdministrationView view) {
    this.view = view;
  }

  void logOut() {
    view.logOut();
  }


}