import 'package:book_store_application/MVP/Model/BookInCart.dart';
import 'package:book_store_application/MVP/Model/Order.dart';
import 'package:book_store_application/MVP/Model/User.dart';
import 'package:book_store_application/firebase/providers/default_waitingOrders_provider.dart';
import 'package:book_store_application/screens/admin_orders/order_cart_admin.dart';
import 'package:book_store_application/screens/dismissible_widget.dart';
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

  List<Order> listWaitingOrders = [];
  List<Order> listPreparingOrders = [];
  List<Order> listDeliveringOrders = [];
  List<Order> listReceivedOrders = [];

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
                            OrderPlaceWidgetPreparing(context, 1),
                            OrderPlaceWidgetDelivering(context, 2),
                            OrderPlaceWidgetReceived(context, 3),
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
    return FutureBuilder(
        future: getOrdersByStatus(status),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else
            {
            var orders = snapshot.data as List<Order>;
            if (orders == null || orders.length == 0) {
                listWaitingOrders = defaultWaitingOrdersProvider.getWaitingOrders();
                if(listWaitingOrders.length == 0) return Center(child:Text("You have O order"));
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
                                child: DismissibleWidget(
                                    item: item,
                                    child: OrderCardAdmin(item),
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
                                        case DismissDirection.startToEnd:
                                          String user_id = item.getUSER_ID();
                                          String order_id = item.getID();
                                          refOrders.child(user_id).child(order_id).update(
                                              {'status': 1});
                                          defaultWaitingOrdersProvider.updateStatus(order_id, 1);
                                          setState(() {
                                            List<Order> updateList = [];
                                            for(int i = 0; i < listWaitingOrders.length; i++) {
                                              if(listWaitingOrders[i].getID() == order_id) listWaitingOrders[i].setSTATUS(1);
                                              if(listWaitingOrders[i].getSTATUS() == 1) updateList.add(listWaitingOrders[i]);
                                            }
                                            listWaitingOrders = updateList;
                                          });

                                          Fluttertoast.showToast(
                                              msg: 'Move this order to next stage successfully',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM);
                                          break;
                                        default:
                                          break;
                                      }
                                    }
                                )

                          );

                        }
                    ),
                    )
                  );
                }
              }
            else {
              List<Order> tempList = defaultWaitingOrdersProvider.getWaitingOrders();
              if(tempList.length > orders.length) listWaitingOrders = tempList;
              else listWaitingOrders = orders;
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
                        child: DismissibleWidget(
                          item: item,
                          child: OrderCardAdmin(item),
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
                              case DismissDirection.startToEnd:
                                String user_id = item.getUSER_ID();
                                String order_id = item.getID();
                                refOrders.child(user_id).child(order_id).update(
                                    {'status': 1});
                                defaultWaitingOrdersProvider.updateStatus(order_id, 1);
                                setState(() {
                                  List<Order> updateList = [];
                                  for(int i = 0; i < listWaitingOrders.length; i++) {
                                    if(listWaitingOrders[i].getID() == order_id) listWaitingOrders[i].setSTATUS(1);
                                    if(listWaitingOrders[i].getSTATUS() == 1) updateList.add(listWaitingOrders[i]);
                                  }
                                  listWaitingOrders = updateList;
                                });

                                Fluttertoast.showToast(
                                    msg: 'Move this order to next stage successfully',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM);
                                break;
                              default:
                                break;
                            }

                            }
                        )
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

  Widget OrderPlaceWidgetPreparing(BuildContext context,int status) {
    final defaultWaitingOrdersProvider = Provider.of<DefaultWaitingOrderProvider>(context);
    return FutureBuilder(
        future: getOrdersByStatus(status),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else{
            var orders = snapshot.data as List<Order>;
            if (orders == null || orders.length == 0) {
              listPreparingOrders = defaultWaitingOrdersProvider.getPreparingOrders();
              if(listPreparingOrders.length == 0) return Center(child:Text("You have O order"));
              else {
                return
                  SingleChildScrollView(
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
                          child: DismissibleWidget(
                              item: item,
                              child: OrderCardAdmin(item),
                              onDismissed: (direction) async {
                                setState(() {
                                  listPreparingOrders.removeAt(index);
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
                                  case DismissDirection.startToEnd:
                                    String user_id = item.getUSER_ID();
                                    String order_id = item.getID();
                                    refOrders.child(user_id).child(order_id).update(
                                        {'status': 2});
                                    defaultWaitingOrdersProvider.updateStatus(order_id, 2);
                                    setState(() {
                                      List<Order> updateList = [];
                                      for(int i = 0; i < listPreparingOrders.length; i++) {
                                        if(listPreparingOrders[i].getID() == order_id) listPreparingOrders[i].setSTATUS(2);
                                        if(listPreparingOrders[i].getSTATUS() == 2) updateList.add(listPreparingOrders[i]);
                                      }
                                      listPreparingOrders = updateList;
                                    });

                                    Fluttertoast.showToast(
                                        msg: 'Move this order to next stage successfully',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM);
                                    break;
                                  default:
                                    break;
                                }
                              }
                          )
                      );
                    }
                    )
                      )
                  );
              }
            }
            else {
              List<Order> tempList = defaultWaitingOrdersProvider.getPreparingOrders();
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
                        child: DismissibleWidget(
                            item: item,
                            child: OrderCardAdmin(item),
                            onDismissed: (direction) async {
                              setState(() {
                                listPreparingOrders.removeAt(index);
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
                                case DismissDirection.startToEnd:
                                  String user_id = item.getUSER_ID();
                                  String order_id = item.getID();
                                  refOrders.child(user_id).child(order_id).update(
                                      {'status': 2});
                                  defaultWaitingOrdersProvider.updateStatus(order_id, 2);
                                  setState(() {
                                    List<Order> updateList = [];
                                    for(int i = 0; i < listPreparingOrders.length; i++) {
                                      if(listPreparingOrders[i].getID() == order_id) listPreparingOrders[i].setSTATUS(2);
                                      if(listPreparingOrders[i].getSTATUS() == 2) updateList.add(listPreparingOrders[i]);
                                    }
                                    listPreparingOrders = updateList;
                                  });

                                  Fluttertoast.showToast(
                                      msg: 'Move this order to next stage successfully',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM);
                                  break;
                                default:
                                  break;
                              }

                            }
                        )
                    );
                  }
          ))
              );
            }

          }
        }
    );
  }

  Widget OrderPlaceWidgetDelivering(BuildContext context,int status) {
    final defaultWaitingOrdersProvider = Provider.of<DefaultWaitingOrderProvider>(context);
    return FutureBuilder(
        future: getOrdersByStatus(status),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else{
            var orders = snapshot.data as List<Order>;
            if (orders == null || orders.length == 0) {
              listDeliveringOrders = defaultWaitingOrdersProvider.getDeliveringOrders();
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
                        child: Dismissible(
                            key: ObjectKey(item),
                            background: buildSwipeActionLeft(),
                            direction: DismissDirection.startToEnd,
                            child: OrderCardAdmin(item),
                            onDismissed: (direction) async {
                              setState(() {
                                listDeliveringOrders.removeAt(index);
                              });
                              switch (direction) {
                                case DismissDirection.startToEnd:
                                  String user_id = item.getUSER_ID();
                                  String order_id = item.getID();
                                  refOrders.child(user_id).child(order_id).update(
                                      {'status': 3});
                                  defaultWaitingOrdersProvider.updateStatus(order_id, 3);
                                  setState(() {
                                    List<Order> updateList = [];
                                    for(int i = 0; i < listDeliveringOrders.length; i++) {
                                      if(listDeliveringOrders[i].getID() == order_id) listDeliveringOrders[i].setSTATUS(3);
                                      if(listDeliveringOrders[i].getSTATUS() == 3) updateList.add(listDeliveringOrders[i]);
                                    }
                                    listDeliveringOrders = updateList;
                                  });
                                  Fluttertoast.showToast(
                                      msg: 'Move this order to next stage successfully',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM);
                                  break;
                                default:
                                  break;
                              }
                            }
                        ),
                      );
                    }
          )));
              }
            }
            else {
              List<Order> tempList = defaultWaitingOrdersProvider.getDeliveringOrders();
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
                        child: Dismissible(
                          key: ObjectKey(item),
                          background: buildSwipeActionLeft(),
                          direction: DismissDirection.startToEnd,
                          child: OrderCardAdmin(item),
                          onDismissed: (direction) async {
                            setState(() {
                              listDeliveringOrders.removeAt(index);
                            });
                            switch (direction) {
                              case DismissDirection.startToEnd:
                                String user_id = item.getUSER_ID();
                                String order_id = item.getID();
                                refOrders.child(user_id).child(order_id).update(
                                    {'status': 3});
                                defaultWaitingOrdersProvider.updateStatus(order_id, 3);
                                setState(() {
                                  List<Order> updateList = [];
                                  for(int i = 0; i < listDeliveringOrders.length; i++) {
                                    if(listDeliveringOrders[i].getID() == order_id) listDeliveringOrders[i].setSTATUS(3);
                                    if(listDeliveringOrders[i].getSTATUS() == 3) updateList.add(listDeliveringOrders[i]);
                                  }
                                  listDeliveringOrders = updateList;
                                });
                                Fluttertoast.showToast(
                                    msg: 'Move this order to next stage successfully',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM);
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


Widget buildSwipeActionLeft() => Container(
  height: 200,
  alignment: Alignment.centerLeft,
  padding: EdgeInsets.symmetric(horizontal: 20),
  color: Colors.green,
  child: Icon(Icons.check_box_sharp, color: Colors.white, size: 32),
);

  Widget OrderPlaceWidgetReceived(BuildContext context,int status) {
    final defaultWaitingOrdersProvider = Provider.of<DefaultWaitingOrderProvider>(context);
    return FutureBuilder(
        future: getOrdersByStatus(status),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else{
            var orders = snapshot.data as List<Order>;
            if (orders == null || orders.length == 0) {
              listReceivedOrders = defaultWaitingOrdersProvider.getReceivedOrders();
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
                        child: OrderCardAdmin(item),
                      );
                    }
          )
                    )
                );
              }
            }
            else {
              List<Order> tempList = defaultWaitingOrdersProvider.getReceivedOrders();
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
                  scrollDirection: Axis.vertical,
                  itemCount: listReceivedOrders.length,
                  itemBuilder:(context,index){
                    final item = listReceivedOrders[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: OrderCardAdmin(item),
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
