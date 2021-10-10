import 'package:book_store_application/MVP/View/bestSeller_view.dart';

class BestSellerPresenter {
  late BestSellerView view;

  BestSellerPresenter(BestSellerView view) {
    this.view = view;
  }

  void getBooks(){
    view.getBooks();
  }
}