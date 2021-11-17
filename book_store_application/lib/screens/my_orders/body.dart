import 'package:book_store_application/MVP/Model/BookInCart.dart';
import 'package:book_store_application/MVP/Model/Order.dart';
import 'package:book_store_application/MVP/Model/User.dart';
import 'package:book_store_application/firebase/providers/default_waitingOrders_provider.dart';
import 'package:book_store_application/firebase/providers/order_provider.dart';
import 'package:book_store_application/screens/cart/cart_screen.dart';
import 'package:book_store_application/screens/my_orders/order_detail.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../dismissible_widget.dart';
import 'order_card.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}


class _BodyState extends State<Body> with SingleTickerProviderStateMixin {

  final DatabaseReference refOrders = FirebaseDatabase.instance.reference().child('Orders');
  final DatabaseReference refInventory = FirebaseDatabase.instance.reference().child('Inventory');

  List<Order> listWaitingOrders = [];
  List<Order> listPreparingOrders = [];
  List<Order> listDeliveringOrders = [];
  List<Order> listReceivedOrders = [];

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
                  Tab(child: Text("Waiting", style: TextStyle(color: Colors.black),),),
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
                        OrderPlaceWidgetPreparing(context, 1, user_id),
                        OrderPlaceWidgetDelivering(context, 2, user_id),
                        OrderPlaceWidgetReceived(context, 3, user_id),
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

  Widget buildSwipeActionRight() => Container(
    height: 200,
    alignment: Alignment.centerRight,
    padding: EdgeInsets.symmetric(horizontal: 20),
    color: Colors.red,
    child: Icon(Icons.delete, color: Colors.white, size: 32),
  );

  Widget OrderPlaceWidgetWaiting(BuildContext context,int status, user_id) {
    final defaultWaitingOrdersProvider = Provider.of<DefaultWaitingOrderProvider>(context);
     return FutureBuilder(
         future: getOrdersByStatus(user_id, status),
         builder: (context, snapshot){
           if(snapshot.connectionState == ConnectionState.waiting)
             return Center(child: CircularProgressIndicator());
           else{
             var orders = snapshot.data as List<Order>;
             if (orders == null || orders.length == 0) {
               listWaitingOrders =
                   defaultWaitingOrdersProvider.getWaitingOrdersOfUser(user_id);
               if (listWaitingOrders.length == 0)
                 return Center(child: Text("You have O order"));
               else {
                 return SingleChildScrollView(
                     child: Container(
                     height: MediaQuery.of(context).size.height - 125,
                     width: MediaQuery.of(context).size.width,
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(20),
                     ),
                   child: ListView.builder(
                     physics: BouncingScrollPhysics(),
                     scrollDirection: Axis.vertical,
                     itemCount: listWaitingOrders.length,
                     itemBuilder:(context,index){
                       final item = listWaitingOrders[index];
                       return Padding(
                         padding: EdgeInsets.symmetric(horizontal: 10),
                         child: Dismissible(
                             key: ObjectKey(item),
                             background: buildSwipeActionRight(),
                             direction: DismissDirection.endToStart,
                             child: OrderCard(item),
                             onDismissed: (direction) async {
                               setState(() {
                                 listWaitingOrders.removeAt(index);
                               });
                               switch (direction) {
                                 case DismissDirection.endToStart:
                                   int count = 0;
                                   for (int i = 0; i < item.getBooksInCart().length; i++) {
                                     count++;
                                     await refInventory.child(item.getBooksInCart()[i].getID().toString()).once().then((DataSnapshot dataSnapshot) {
                                       if (dataSnapshot.exists) {
                                         int available = dataSnapshot.value['quantity'];
                                         int update_available = available + item.getBooksInCart()[i].getQUANTITY();
                                         refInventory.child(item.getBooksInCart()[i].getID().toString()).update(
                                             {'quantity': update_available});
                                       }
                                     });
                                     if (count == item.getBooksInCart().length) {
                                       await refOrders.child(item.getUSER_ID()).child(item.getID()).remove();
                                       defaultWaitingOrdersProvider.removeOrder(item.getID());
                                       Fluttertoast.showToast(
                                           msg: 'Delete this order successfully',
                                           toastLength: Toast.LENGTH_SHORT,
                                           gravity: ToastGravity.BOTTOM);
                                     }
                                   }
                                   break;
                                 default:
                                   break;
                               }
                             }
                         ),
                       );
                     }
                     )
                 )
                 );
               }
             }
             else {
               List<Order> tempList = defaultWaitingOrdersProvider.getPreparingOrdersOfUser(user_id);
               if(tempList.length > orders.length) listWaitingOrders = tempList;
               else listWaitingOrders = orders;
               return SingleChildScrollView(
                 child:Container(
                     height: MediaQuery.of(context).size.height - 125,
                     width: MediaQuery.of(context).size.width,
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(20),
                     ),
                     child: ListView.builder(
                   physics: BouncingScrollPhysics(),
                   scrollDirection: Axis.vertical,
                   itemCount: listWaitingOrders.length,
                   itemBuilder:(context,index){
                     final item = listWaitingOrders[index];
                     return Padding(
                       padding: EdgeInsets.symmetric(horizontal: 10),
                       child: Dismissible(
                           key: ObjectKey(item),
                           background: buildSwipeActionRight(),
                           direction: DismissDirection.endToStart,
                           child: OrderCard(item),
                           onDismissed: (direction) async {
                             setState(() {
                               listWaitingOrders.removeAt(index);
                             });
                             switch (direction) {
                               case DismissDirection.endToStart:
                                 int count = 0;
                                 for (int i = 0; i < item.getBooksInCart().length; i++) {
                                   count++;
                                   await refInventory.child(item.getBooksInCart()[i].getID().toString()).once().then((DataSnapshot dataSnapshot) {
                                     if (dataSnapshot.exists) {
                                       int available = dataSnapshot.value['quantity'];
                                       int update_available = available + item.getBooksInCart()[i].getQUANTITY();
                                       refInventory.child(item.getBooksInCart()[i].getID().toString()).update(
                                           {'quantity': update_available});
                                     }
                                   });
                                   if (count == item.getBooksInCart().length) {
                                     await refOrders.child(item.getUSER_ID()).child(item.getID()).remove();
                                     defaultWaitingOrdersProvider.removeOrder(item.getID());
                                     Fluttertoast.showToast(
                                         msg: 'Delete this order successfully',
                                         toastLength: Toast.LENGTH_SHORT,
                                         gravity: ToastGravity.BOTTOM);
                                   }
                                 }
                                 break;
                               default:
                                 break;
                             }
                           }
                       ),
                     );
                   }
                   )
                 )
               );
             }

            }
           }
           );
  }

  Widget OrderPlaceWidgetPreparing(BuildContext context,int status, String user_id) {
    final defaultWaitingOrdersProvider = Provider.of<DefaultWaitingOrderProvider>(context);
    return FutureBuilder(
        future: getOrdersByStatus(user_id, status),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else{
            var orders = snapshot.data as List<Order>;
            if (orders == null || orders.length == 0) {
              listPreparingOrders = defaultWaitingOrdersProvider.getPreparingOrdersOfUser(user_id);
              if(listPreparingOrders.length == 0) return Center(child:Text("You have O order"));
              else {
                return SingleChildScrollView(
                    child:Container(
                        height: MediaQuery.of(context).size.height - 125,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: listPreparingOrders.length,
                    itemBuilder:(context,index){
                      final item = listPreparingOrders[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: OrderCard(item),
                      );
                    }
                    )
                )
                );
              }
            }
            else {
              List<Order> tempList = defaultWaitingOrdersProvider.getPreparingOrdersOfUser(user_id);
              if(tempList.length > orders.length) listPreparingOrders = tempList;
              else listPreparingOrders = orders;
              return SingleChildScrollView(
                  child:Container(
                      height: MediaQuery.of(context).size.height - 125,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child:ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: listPreparingOrders.length,
                          itemBuilder:(context,index){
                            final item = listPreparingOrders[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: OrderCard(item),
                            );
                          }
                      )
                  )
              );
            }
          }
        }
    );
  }

  Widget OrderPlaceWidgetDelivering(BuildContext context,int status, String user_id) {
    final defaultWaitingOrdersProvider = Provider.of<DefaultWaitingOrderProvider>(context);
    return FutureBuilder(
        future: getOrdersByStatus(user_id, status),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else{
            var orders = snapshot.data as List<Order>;
            if (orders == null || orders.length == 0) {
              listDeliveringOrders = defaultWaitingOrdersProvider.getDeliveringOrdersOfUser(user_id);
              if(listDeliveringOrders.length == 0) return Center(child:Text("You have O order"));
              else {
                return SingleChildScrollView(
                    child:Container(
                    height: MediaQuery.of(context).size.height - 125,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          ),
          child:ListView.builder(
              physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: listDeliveringOrders.length,
                    itemBuilder:(context,index){
                      final item = listDeliveringOrders[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: OrderCard(item),
                      );
                    }
                    )
                    )
                );
              }
            }
            else {
              List<Order> tempList = defaultWaitingOrdersProvider.getDeliveringOrdersOfUser(user_id);
              if(tempList.length > orders.length) listDeliveringOrders = tempList;
              else listDeliveringOrders = orders;
              return SingleChildScrollView(
                  child:Container(
                  height: MediaQuery.of(context).size.height - 125,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          ),
          child:ListView.builder(
              physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: listDeliveringOrders.length,
                  itemBuilder:(context,index){
                    final item = listDeliveringOrders[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: OrderCard(item),
                    );
                  }
                  )
                  )
              );
            }

          }
        }
    );
  }

  Widget OrderPlaceWidgetReceived(BuildContext context,int status, String user_id) {
    final defaultWaitingOrdersProvider = Provider.of<DefaultWaitingOrderProvider>(context);
    return FutureBuilder(
        future: getOrdersByStatus(user_id, status),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else{
            var orders = snapshot.data as List<Order>;
            if (orders == null || orders.length == 0) {
              listReceivedOrders = defaultWaitingOrdersProvider.getReceivedOrdersOfUser(user_id);
              if(listReceivedOrders.length == 0) return Center(child:Text("You have O order"));
              else {
                return SingleChildScrollView(
                    child:Container(
                    height: MediaQuery.of(context).size.height - 125,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          ),
          child:ListView.builder(
              physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: listReceivedOrders.length,
                    itemBuilder:(context,index){
                      final item = listReceivedOrders[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: OrderCard(item),
                      );
                    }
          )));
              }
            }
            else {
              List<Order> tempList = defaultWaitingOrdersProvider.getReceivedOrdersOfUser(user_id);
              if(tempList.length > orders.length) listReceivedOrders = tempList;
              else listReceivedOrders = orders;
              return SingleChildScrollView(
                  child:Container(
                  height: MediaQuery.of(context).size.height - 125,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          ),
          child:ListView.builder(
              physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: listReceivedOrders.length,
                  itemBuilder:(context,index){
                    final item = listReceivedOrders[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: OrderCard(item),
                    );
                  }
          )
                  )
              );
            }

          }
        }
    );
  }

  Future<List<Order>> getOrdersByStatus(String User_ID, int Status) async {
    List<Order> orders = [];
    await refOrders.child(User_ID).orderByChild('created').limitToLast(10).once().then((DataSnapshot snapshot1){
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
            print(snapshot2.value);
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

