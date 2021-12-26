import 'package:book_store_application/MVP/Model/User.dart';
import 'package:book_store_application/screens/favourite/fav_book_list_view.dart';
import 'package:book_store_application/screens/my_orders/order_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  List<int> favorites = [];
  Body(List<int> list) {
    this.favorites = list;
  }

  @override
  _BodyState createState() => _BodyState(this.favorites);
}

class _BodyState extends State<Body> {
  List<int> favorites = [];
  _BodyState(List<int> list) {
    this.favorites = list;
  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User_MD?>(context);
    String user_id = "";
    if(user!.uid != null) user_id = user.uid.toString();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  child: Row(
                    children: const [
                      Icon(Icons.navigate_before, color: Colors.black, size: 35,),
                      Text("Back",
                        style: TextStyle(color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w400),)
                    ],
                  ),
                  onPressed: () { Navigator.pop(context);},
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg2.png"),
            fit: BoxFit.cover,
          ),
        ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 70,),
          Flexible(
            child: FavouriteBookListView(
              callBack: () {
                moveTo();
              },
              favorites: favorites,
            ),
          )
        ],
      ),)
    );
  }

  void moveTo() {
    /*Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => OrdersDetailScreen(),
      ),
    );*/
  }

}



