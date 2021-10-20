class BookInCart{

  late int id;
  late int quantity;
  late String title;
  late double total_price;

  BookInCart(int ID, String TITLE, int QUANTITY, double TOTAL_PRICE) {
    this.id = ID;
    this.quantity = QUANTITY;
    this.total_price = TOTAL_PRICE;
    this.title = TITLE;
  }

  int getID() {return this.id;}
  void setID(int ID) {this.id = ID;}

  int getQUANTITY() {return this.quantity;}
  void setQUANTITY(int QUANTITY) {this.quantity = QUANTITY;}

  String getTITLE() {return this.title;}
  void setTITLE(String TITLE) {this.title = TITLE;}

  double getTOTAL_PRICE() {return this.total_price;}
  void setTOTAL_PRICE(double TOTAL_PRICE) {this.total_price = TOTAL_PRICE;}


  /*OrderModel.fromSnapshot(DocumentSnapshot snapshot){
    _id = snapshot.data[ID];
    _description = snapshot.data[DESCRIPTION];
    _total = snapshot.data[TOTAL];
    _status = snapshot.data[STATUS];
    _userId = snapshot.data[USER_ID];
    _createdAt = snapshot.data[CREATED_AT];
    _restaurantId = snapshot.data[RESTAURANT_ID];
    cart = snapshot.data[CART];
  }*/









}