import 'package:book_store_application/MVP/Model/BookInCart.dart';
import 'package:flutter/cupertino.dart';

class OrderProvider with ChangeNotifier{

  List<BookInCart> booksInCart = [];
  List<BookInCart> newBooksInCart = [];
  double total_price = 0;

  OrderProvider.initialize(){

  }

  List<BookInCart> getBooksInCart() {
    return booksInCart;
  }

  void addBookInCart(int ID, String TITLE, int QUANTITY, double TOTAL_PRICE) {
    BookInCart bookInCart = new BookInCart(ID, TITLE, QUANTITY, TOTAL_PRICE);
    booksInCart.add(bookInCart);
    notifyListeners();
  }

  void removeBookCart(int ID) {
    for (int i = 0; i < booksInCart.length; i++) {
      if(booksInCart[i].getID() == ID) booksInCart.removeAt(i);
    }
    notifyListeners();
  }

  void updateExtraQuantityAndTotalPrice(int ID, int QUANTITY) {
    for (int i = 0; i < booksInCart.length; i++) {
      if(booksInCart[i].getID() == ID) {
        int old_quantity = booksInCart[i].getQUANTITY();
        double price = booksInCart[i].getTOTAL_PRICE() / old_quantity;
        int new_quantity = old_quantity + QUANTITY;
        double total_price = price * new_quantity;
        booksInCart[i].setQUANTITY(new_quantity);
        booksInCart[i].setTOTAL_PRICE(total_price);
      }
    }
    notifyListeners();
  }

  void updateQuantityAndTotalPrice(int ID, int QUANTITY) {
    for (int i = 0; i < booksInCart.length; i++) {
      if(booksInCart[i].getID() == ID) {
        int old_quantity = booksInCart[i].getQUANTITY();
        double price = booksInCart[i].getTOTAL_PRICE() / old_quantity;
        int new_quantity = QUANTITY;
        double total_price = price * new_quantity;
        booksInCart[i].setQUANTITY(new_quantity);
        booksInCart[i].setTOTAL_PRICE(total_price);
      }
    }
    notifyListeners();;
  }

  void calculateTotalPrice() {
    double temp = 0;
    for (int i = 0; i < booksInCart.length; i++) {
      temp+= booksInCart[i].getTOTAL_PRICE();
    }
    total_price = temp;
    notifyListeners();
  }

  void throwBookSInCart() {
    booksInCart = newBooksInCart;
    total_price = 0;
    notifyListeners();
  }

}