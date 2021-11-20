import 'package:cloud_firestore/cloud_firestore.dart';

class Book {

  late int id;
  late int author_id;
  late int category_id;
  late String genre;
  List<String> image_url = [];
  late double price;
  late int publisher_id;
  late int publishing_year;
  late int sold_count;
  late String summary;
  late String title;

  Book(int ID, int AUTHOR_ID,int CATEGORY_ID, String GENRE, List<String> IMAGE_URL, double PRICE, int PUBLISHER_ID,
      int PUBLISHING_YEAR, int SOLD_COUNT, String SUMMARY, String TITLE) {
    this.id = ID;
    this.author_id = AUTHOR_ID;
    this.category_id = CATEGORY_ID;
    this.genre = GENRE;
    this.image_url = IMAGE_URL;
    this.price = PRICE;
    this.publisher_id = PUBLISHER_ID;
    this.publishing_year = PUBLISHING_YEAR;
    this.sold_count = SOLD_COUNT;
    this.summary = SUMMARY;
    this.title = TITLE;
  }

  int getID() {return this.id;}
  void setID(int ID) {this.id = ID;}

  int getAUTHOR_ID() {return this.author_id;}
  void setAUTHOR_ID(int AUTHOR_ID) {this.author_id = AUTHOR_ID;}

  String getGENRE() {return this.genre;}
  void setGENRE(String GENRE) {this.genre = GENRE;}

  void setFAVORITE(String GENRE) {this.genre = GENRE;}

  int getCATEGORY_ID() {return this.category_id;}
  void setCATEGORY_ID(int CATEGORY_ID) {this.category_id = CATEGORY_ID;}

  List<String> getList_IMAGE_URL() {return this.image_url;}
  void setIMAGE_URL(List<String> IMAGE_URL) {this.image_url = IMAGE_URL;}

  String getIMAGE_URL() {return this.image_url[0];}

  double getPRICE() {return this.price;}
  void setPRICE(double PRICE) {this.price = PRICE;}

  int getPUBLISHER_ID() {return this.publisher_id;}
  void setPUBLISHER_ID(int PUBLISHER_ID) {this.publisher_id = PUBLISHER_ID;}

  int getPUBLISHING_YEAR() {return this.publishing_year;}
  void setPUBLISHING_YEAR(int PUBLISHING_YEAR) {this.publishing_year = PUBLISHING_YEAR;}

  int getSOLD_COUNT() {return this.sold_count;}
  void setSOLD_COUNT(int SOLD_COUNT) {this.sold_count = SOLD_COUNT;}

  String getSUMMARY() {return this.summary;}
  void setSUMMARY(String SUMMARY) {this.summary = SUMMARY;}

  String getTITLE() {return this.title;}
  void setTITLE(String TITLE) {this.title = TITLE;}

  Book.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.get('book_id');
    author_id = snapshot.get('author_id');
    genre = snapshot.get('genre');
    category_id = snapshot.get('category_id');
    for(int i = 0; i < 3; i++) {
      if(snapshot.get('image_url')[i].toString().trim() != "") image_url.add(snapshot.get('image_url')[i]);
      else image_url.add("");
    }
    int iPrice = snapshot.get('price');
    price = iPrice.toDouble();
    publisher_id = snapshot.get('publisher_id');
    publishing_year = snapshot.get('publishing_year');
    sold_count = snapshot.get('sold_count');
    title = snapshot.get('title');
    summary = snapshot.get('summary');
  }

}