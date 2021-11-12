import 'package:book_store_application/MVP/Model/BookInCart.dart';
import 'package:book_store_application/MVP/Model/Order.dart';
import 'package:book_store_application/MVP/Model/User.dart';
import 'package:book_store_application/firebase/providers/default_waitingOrders_provider.dart';
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
                            OrderPlaceWidgetWaiting(context, 0),
                            OrderPlaceWidgetWaiting(context, 1),
                            OrderPlaceWidget(context, 2),
                            OrderPlaceWidget(context, 3),
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

  Widget OrderPlaceWidgetWaiting(BuildContext context,int status) {
    final defaultWaitingOrdersProvider = Provider.of<DefaultWaitingOrderProvider>(context);
    List<Order> defaultWaitingOrders = defaultWaitingOrdersProvider.orders;
    return FutureBuilder(
        future: getOrdersByStatus(status),
        builder: (context, snapshot){

          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else{
            var orders = snapshot.data as List<Order>;
            if (orders == null || orders.length == 0) {
              if(status == 0) {
                if(defaultWaitingOrders.length == 0) return Center(child:Text("You have O order"));
                else {
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: defaultWaitingOrders.length,
                      itemBuilder:(context,index){
                        return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Dismissible(
                              key: Key(defaultWaitingOrders[index].getID().toString()),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) async {
                                  if (status == 0) {
                                    int count = 0;
                                    for (int i = 0; i < defaultWaitingOrders[index]
                                        .getBooksInCart()
                                        .length; i++) {
                                      count++;
                                      await refInventory.child(
                                          defaultWaitingOrders[index].getBooksInCart()[i]
                                              .getID()
                                              .toString()).once().then((
                                          DataSnapshot dataSnapshot) {
                                        if (dataSnapshot.exists) {
                                          int available = dataSnapshot
                                              .value['quantity'];
                                          int update_available = available +
                                              defaultWaitingOrders[index].getBooksInCart()[i]
                                                  .getQUANTITY();
                                          refInventory.child(
                                              defaultWaitingOrders[index].getBooksInCart()[i]
                                                  .getID()
                                                  .toString()).update(
                                              {'quantity': update_available});
                                        }
                                      });
                                      if (count == defaultWaitingOrders[index]
                                          .getBooksInCart()
                                          .length) {
                                        await refOrders.child(defaultWaitingOrders[index].getUSER_ID()).child(
                                            defaultWaitingOrders[index].getID()).remove();
                                        defaultWaitingOrdersProvider.removeOrder(defaultWaitingOrders[index].getID());
                                        Fluttertoast.showToast(
                                            msg: 'Delete this order successfully',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM);
                                      }
                                    }
                                  }
                                  else
                                    Fluttertoast.showToast(
                                        msg: "Some errors happened.",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM);
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
                              child: OrderCardAdmin(defaultWaitingOrders[index]),
                            ));
                      }

                  );
                }
              }
              else return Center(child:Text("You have O order"));
            }
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
                          onDismissed: (direction) async {
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
                                          orders[index].getBooksInCart()[i]
                                              .getID()
                                              .toString()).update(
                                          {'quantity': update_available});
                                    }
                                  });
                                  if (count == orders[index]
                                      .getBooksInCart()
                                      .length) {
                                    await refOrders.child(orders[index].getUSER_ID()).child(
                                        orders[index].getID()).remove();
                                    defaultWaitingOrdersProvider.removeOrder(orders[index].getID());
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

  Widget OrderPlaceWidget(BuildContext context,int status) {
    return FutureBuilder(
        future: getOrdersByStatus(status),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else{
            var orders = snapshot.data as List<Order>;
            if (orders == null || orders.length == 0) {
              return Center(child:Text("You have O order"));
            }
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

  Future<List<Order>> getOrdersByStatus(int Status) async {
    List<Order> orders = [];
    await refOrders.limitToLast(10).once().then((DataSnapshot snapshot1) {
      Map<dynamic, dynamic> values1 = snapshot1.value;
      values1.forEach((key, values1) async {
        String user_id = key;
        refOrders.child(user_id).orderByChild('created').limitToLast(10).once().then((DataSnapshot snapshot2) {
          Map<dynamic, dynamic> values2 = snapshot2.value;
          values2.forEach((key, values2) async {
            List<BookInCart> books = [];
            String order_id = values2['order_id'].toString();
            String address = values2['address'].toString();
            String date = values2['date'].toString();
            String name = values2['name'].toString();
            String phone = values2['phone'].toString();
            int status = int.parse(values2['status'].toString());
            double total_price = double.parse(
                values2['total_price'].toString());
            String user_ID = values2['user_id'].toString();

            if(status == Status) {
              refOrders.child(user_ID).child(order_id).child('book_id')
                  .once()
                  .then((DataSnapshot snapshot3) {
                List<dynamic> result = snapshot3.value;
                result.forEach((value) {
                  int book_id = int.parse(value['id'].toString());
                  int quantity = int.parse(value['quantity'].toString());
                  String title = value['title'].toString();
                  double total = double.parse(value['total_price'].toString());
                  BookInCart book = new BookInCart(
                      book_id, title, quantity, total);
                  books.add(book);
                });
              });
              Order order = new Order(order_id, user_ID, name, phone, address, books, total_price, status, date);
              orders.add(order);
            }
          });
        });
      });
    });

    return orders;
  }

}
