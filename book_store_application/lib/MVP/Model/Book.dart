import 'package:cloud_firestore/cloud_firestore.dart';

class Book {

  late int id;
  late int author_id;
  late int favorite;
  late int genre_id;
  List<String> image_url = List.empty();
  late double price;
  late int publisher_id;
  late int publishing_year;
  late int quantity;
  late int sold_count;
  late String summary;
  late String title;

  Book(int ID, int AUTHOR_ID, int FAVORITE, int GENRE_ID, List<String> IMAGE_URL, double PRICE, int PUBLISHER_ID,
      int PUBLISHING_YEAR, int QUANTITY, int SOLD_COUNT, String SUMMARY, String TITLE) {
    this.id = ID;
    this.author_id = AUTHOR_ID;
    this.favorite = FAVORITE;
    this.genre_id = GENRE_ID;
    this.image_url = IMAGE_URL;
    this.price = PRICE;
    this.publisher_id = PUBLISHER_ID;
    this.publishing_year = PUBLISHING_YEAR;
    this.quantity = QUANTITY;
    this.sold_count = SOLD_COUNT;
    this.summary = SUMMARY;
    this.title = TITLE;
  }

  int getID() {return this.id;}
  void setID(int ID) {this.id = ID;}

  int getAUTHOR_ID() {return this.author_id;}
  void setAUTHOR_ID(int AUTHOR_ID) {this.author_id = AUTHOR_ID;}

  int getFAVORITE() {return this.favorite;}
  void setFAVORITE(int FAVORITE) {this.favorite = favorite;}

  int getGENRE_ID() {return this.genre_id;}
  void setGENRE_ID(int GENRE_ID) {this.genre_id = GENRE_ID;}

  List<String> getList_IMAGE_URL() {return this.image_url;}
  void setIMAGE_URL(List<String> IMAGE_URL) {this.image_url = IMAGE_URL;}

  String getIMAGE_URL() {return this.image_url[0];}

  double getPRICE() {return this.price;}
  void setPRICE(double PRICE) {this.price = PRICE;}

  int getPUBLISHER_ID() {return this.publisher_id;}
  void setPUBLISHER_ID(int PUBLISHER_ID) {this.publisher_id = PUBLISHER_ID;}

  int getPUBLISHING_YEAR() {return this.publishing_year;}
  void setPUBLISHING_YEAR(int PUBLISHING_YEAR) {this.publishing_year = PUBLISHING_YEAR;}

  int getQUANTITY() {return this.quantity;}
  void setQUANTITY(int QUANTITY) {this.quantity = QUANTITY;}

  int getSOLD_COUNT() {return this.sold_count;}
  void setSOLD_COUNT(int SOLD_COUNT) {this.sold_count = SOLD_COUNT;}

  String getSUMMARY() {return this.summary;}
  void setSUMMARY(String SUMMARY) {this.summary = SUMMARY;}

  String getTITLE() {return this.title;}
  void setTITLE(String TITLE) {this.title = TITLE;}

  Book.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.get('book_id');
    author_id = snapshot.get('author_id');
    favorite = snapshot.get('favorite');
    genre_id = snapshot.get('genre_id');
    for(int i = 0; i < 3; i++) {
      if(snapshot.get('image_url')[i].toString().trim() != "") image_url.add(snapshot.get('image_url')[i]);
      else image_url.add("");
    }
    int iPrice = snapshot.get('price');
    price = iPrice.toDouble();
    publisher_id = snapshot.get('publisher_id');
    publishing_year = snapshot.get('publishing_year');
    quantity = snapshot.get('quantity');
    sold_count = snapshot.get('sold_count');
    title = snapshot.get('title');
    summary = snapshot.get('summary');
  }

}