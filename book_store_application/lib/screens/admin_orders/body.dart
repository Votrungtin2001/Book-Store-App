import 'package:book_store_application/MVP/Model/BookInCart.dart';
import 'package:book_store_application/MVP/Model/Order.dart';
import 'package:book_store_application/MVP/Model/User.dart';
import 'package:book_store_application/screens/admin_orders/order_cart_admin.dart';
import 'package:book_store_application/screens/my_orders/order_card.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  final DatabaseReference refOrders = FirebaseDatabase.instance.reference().child('Orders');
  final DatabaseReference refInventory = FirebaseDatabase.instance.reference().child('Inventory');

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User_MD?>(context);
    String user_id = "";
    if(user!.uid != null) user_id = user.uid.toString();

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home:DefaultTabController(
          length: 4,
          child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                backgroundColor: Colors.transparent,
                actions: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          child: Row(
                            children: const [
                              Icon(
                                Icons.navigate_before, color: Colors.black, size: 30,),
                              Text("Back", style: TextStyle(color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400),),
                            ],
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    TabBar(
                      tabs: [
                        Tab(child: Text("Not Confirm", style: TextStyle(color: Colors.black),),),
                        Tab(child: Text("Preparing",style: TextStyle(color: Colors.black),),),
                        Tab(child: Text("Delivering",style: TextStyle(color: Colors.black),),),
                        Tab(child: Text("Received",style: TextStyle(color: Colors.black),),),
                      ],
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: TabBarView(
                          children: [
                            OrderPlaceWidgetWaiting(context, 0, user_id),
                            OrderPlaceWidgetWaiting(context, 1, user_id),
                            OrderPlaceWidget(context, 2, user_id),
                            OrderPlaceWidget(context, 3, user_id),
                          ],
                        )
                    )
                  ],
                ),
              )
          ),
        )
    );
  }

  Widget OrderPlaceWidgetWaiting(BuildContext context,int status, user_id) {
    return FutureBuilder(
        future: getOrdersByStatus(user_id, status),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else{
            var orders = snapshot.data as List<Order>;
            if (orders == null || orders.length == 0)
              return Center(child:Text("You have O order"));
            else
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: orders.length,
                  itemBuilder:(context,index){
                    return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Dismissible(
                          key: Key(orders[index].getID().toString()),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            setState(() async {
                              if (status == 0) {
                                int count = 0;
                                for (int i = 0; i < orders[index]
                                    .getBooksInCart()
                                    .length; i++) {
                                  count++;
                                  await refInventory.child(
                                      orders[index].getBooksInCart()[i]
                                          .getID()
                                          .toString()).once().then((
                                      DataSnapshot dataSnapshot) {
                                    if (dataSnapshot.exists) {
                                      int available = dataSnapshot
                                          .value['quantity'];
                                      int update_available = available +
                                          orders[index].getBooksInCart()[i]
                                              .getQUANTITY();
                                      refInventory.child(
                                          orders[i].getBooksInCart()[i]
                                              .getID()
                                              .toString()).update(
                                          {'quantity': update_available});
                                    }
                                  });
                                  if (count == orders[index]
                                      .getBooksInCart()
                                      .length) {
                                    await refOrders.child(user_id).child(
                                        orders[index].getID()).remove();
                                    Fluttertoast.showToast(
                                        msg: 'Delete this order successfully',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM);
                                  }
                                }
                              }
                              else
                                Fluttertoast.showToast(
                                    msg: "You can't delete this order. Please contact with us",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM);
                            });
                          },
                          background: Container(
                            height: 200,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Color(0xFFFFE6E6),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Spacer(),
                                SvgPicture.asset("assets/icons/Trash.svg"),
                              ],
                            ),
                          ),
                          child: OrderCardAdmin(orders[index]),
                        ));
                  }

              );
          }
        }
    );
  }

  Widget OrderPlaceWidget(BuildContext context,int status, user_id) {
    return FutureBuilder(
        future: getOrdersByStatus(user_id, status),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else{
            var orders = snapshot.data as List<Order>;
            if (orders == null || orders.length == 0)
              return Center(child:Text("You have O order"));
            else
              return ListView.builder(

                  itemCount: orders.length,
                  itemBuilder:(context,index){
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: OrderCardAdmin(orders[index]),
                    );
                  }
              );
          }
        }
    );
  }

  Future<List<Order>> getOrdersByStatus(String User_ID, int Status) async {
    List<Order> orders = [];
    refOrders.child(User_ID).limitToLast(10).once().then((DataSnapshot snapshot1){
      Map<dynamic, dynamic> values1 = snapshot1.value;
      values1.forEach((key,values1) async {
        List<BookInCart> books = [];
        String order_id = values1['order_id'].toString();
        String address = values1['address'].toString();
        String date = values1['date'].toString();
        String name = values1['name'].toString();
        String phone = values1['phone'].toString();
        int status = int.parse(values1['status'].toString());
        double total_price = double.parse(values1['total_price'].toString());
        String user_id = values1['user_id'].toString();
        if(status == Status) {
          refOrders.child(User_ID).child(order_id).child('book_id').once().then((DataSnapshot snapshot2) {
            List<dynamic> result = snapshot2.value;
            result.forEach((value) {
              int book_id = int.parse(value['id'].toString());
              int quantity = int.parse(value['quantity'].toString());
              String title = value['title'].toString();
              double total = double.parse(value['total_price'].toString());
              BookInCart book = new BookInCart(book_id, title, quantity, total);
              books.add(book);
            });
          });
          Order order = new Order(order_id, user_id, name, phone, address, books, total_price, status, date);
          orders.add(order);
        }
      });
    });
    return orders;
  }
}
