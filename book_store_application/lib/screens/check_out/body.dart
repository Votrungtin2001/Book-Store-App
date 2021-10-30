import 'package:book_store_application/MVP/Model/Order.dart';
import 'package:book_store_application/firebase/providers/order_provider.dart';
import 'package:book_store_application/firebase/providers/user_provider.dart';
import 'package:book_store_application/main_page.dart';
import 'package:book_store_application/screens/change_address_screen.dart';
import 'package:book_store_application/screens/home/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'add_phone_screen.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final DatabaseReference refInventory = FirebaseDatabase.instance.reference().child('Inventory');
  final DatabaseReference refOrder = FirebaseDatabase.instance.reference().child('Orders');
  int available = 0;
  bool sign = false;

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final currencyformat = new NumberFormat("#,###,##0");
    double subTotal = orderProvider.total_price * 0.1;
    double deliveryCost = 35000;
    double total = orderProvider.total_price + deliveryCost + subTotal;

    final user_model = Provider.of<UserProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.arrow_back_ios_rounded,),
                    ),
                    Expanded(
                      child: Text(
                        "Checkout",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                Container(
                  margin: const EdgeInsets.all(16.0),
                  // padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.16),
                          offset: Offset(0, 5),
                          blurRadius: 10.0,
                        )
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Initial price",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16)),
                          Text(
                              currencyformat.format(orderProvider.total_price) + "đ",
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                          )
                        ],
                      ),
                      Divider(
                        height: 40,
                        color: Color(0xFFB6B7B7).withOpacity(0.25),
                        thickness: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Sub Total",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16)),
                          Text(
                            currencyformat.format(subTotal) + "đ",
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                          )
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          Text("Delivery Cost",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16)),
                          Text(
                            currencyformat.format(deliveryCost) + "đ",
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                          )
                        ],
                      ),
                      Divider(
                        height: 40,
                        color: const Color(0xFFB6B7B7).withOpacity(0.25),
                        thickness: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16)),
                          Text(
                            currencyformat.format(total) + "đ",
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                          )
                        ],
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.all(16.0),
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.16),
                          offset: Offset(0, 5),
                          blurRadius: 10.0,
                        )
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 25,),
                      const Text("Delivery Address",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16)),
                      const SizedBox(height: 5,),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                user_model.user.getAddress() == "" ? "Please enter your address" : user_model.user.getAddress(),
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push<dynamic>( context,
                                  MaterialPageRoute<dynamic>(
                                    builder: (BuildContext context) => AddAddressScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                "Change",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                      ),
                      const SizedBox(height: 5,),
                      const Text("Delivery Phone",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16)),
                      const SizedBox(height: 5,),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(user_model.user.getPhone() == "" ? "Please enter your phone number" : user_model.user.getPhone(),
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push<dynamic>( context,
                                  MaterialPageRoute<dynamic>(
                                    builder: (BuildContext context) => AddPhoneScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Change",
                                style: TextStyle(fontWeight: FontWeight.bold,),
                              ),
                            ),
                          ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () async {
                        if(user_model.user.getAddress() == "") {
                          Fluttertoast.showToast(msg: 'Please enter your address.', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
                        }
                        else if (user_model.user.getPhone() == "") {
                          Fluttertoast.showToast(msg: 'Please enter your phone number.', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
                        }
                        else {
                          for(int i = 0; i < orderProvider.booksInCart.length; i++) {
                            await refInventory.child(orderProvider.booksInCart[i].getID().toString())
                                .once().then((DataSnapshot dataSnapshot) {
                              if(dataSnapshot.exists) {
                                setState(() {
                                  available = dataSnapshot.value['quantity'];
                                  if(available < orderProvider.booksInCart[i].getQUANTITY()) sign = true;
                                });
                              }
                            });
                          }
                          if(sign == true) {
                            orderProvider.throwBookSInCart();
                            Navigator.push<dynamic>( context,
                              MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) => MainPage(),
                              ),
                            );
                            Fluttertoast.showToast(msg: 'One of the books in your cart is not enough to provide. Please try again', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
                          }
                          else {
                            final DateTime now = DateTime.now();
                            final DateFormat formatter = DateFormat('dd-MM-yyyy');
                            final String date = formatter.format(now);

                            Order order = new Order("", user_model.user.getID(), user_model.user.getName(), user_model.user.getPhone(),
                                user_model.user.getAddress(), orderProvider.booksInCart, total, 0, date);
                            try {
                              FirebaseFirestore _firestore = FirebaseFirestore.instance;
                              DocumentReference docRef = _firestore.collection('Orders').doc();
                              String id = docRef.id;


                              await refOrder.child(order.getUSER_ID())
                                  .child(id)
                                  .set({'order_id': id, 'user_id': order.getUSER_ID(), 'name': order.getNAME(),
                                'phone': order.getPHONE(), 'address': order.getADDRESS(),
                                'total_price': order.getTOTAL_PRICE(), 'date': order.getDATE(), 'status': order.getSTATUS(), 'created': now.microsecondsSinceEpoch});

                              int count = 0;

                              for(int i = 0; i < order.getBooksInCart().length; i++){
                                await refInventory.child(order.getBooksInCart()[i].getID().toString())
                                    .once().then((DataSnapshot dataSnapshot) {
                                  if(dataSnapshot.exists) {
                                    setState(() {
                                      available = dataSnapshot.value['quantity'];
                                    });
                                  }
                                });
                                int update_available = available - order.getBooksInCart()[i].getQUANTITY();

                                await refInventory.child(order.getBooksInCart()[i].getID().toString())
                                    .update({'quantity': update_available});

                                await refOrder.child(order.getUSER_ID())
                                    .child(id)
                                    .child('book_id')
                                    .child(i.toString())
                                    .update({'id': order.getBooksInCart()[i].getID(),
                                  'title': order.getBooksInCart()[i].getTITLE(),
                                  'quantity': order.getBooksInCart()[i].getQUANTITY(),
                                  'total_price': order.getBooksInCart()[i].getTOTAL_PRICE()});
                                count++;
                                if(count == order.getBooksInCart().length) {
                                  orderProvider.throwBookSInCart();
                                  showModalBottomSheet(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15)
                                        ),
                                      ),
                                      isScrollControlled: true,
                                      isDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          height: MediaQuery.of(context).size.height * 0.7,
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    icon: const Icon(Icons.clear),
                                                  ),
                                                ],
                                              ),
                                              Image.asset("assets/images/vector4.png"),
                                              const SizedBox(height: 20,),
                                              const Text( "Thank You!",
                                                style: TextStyle(
                                                  color: Color(0xFF4A4B4D),
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 30,
                                                ),
                                              ),
                                              const SizedBox(height: 5,),
                                              const Text(
                                                "for your order",
                                                style: TextStyle(fontWeight: FontWeight.w500,color: Color(0xFF4A4B4D)),
                                              ),
                                              const SizedBox(height: 20,),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                                child: Text("Your order is now being processed. We will let you know once the order is picked from the outlet. Check the status of your order!",textAlign: TextAlign.center,),),
                                              const SizedBox(height: 30,),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 20,
                                                ),
                                                child: TextButton(
                                                  onPressed: () {
                                                    Navigator.push<dynamic>( context,
                                                      MaterialPageRoute<dynamic>(
                                                        builder: (BuildContext context) => MainPage(),
                                                      ),
                                                    );
                                                  },
                                                  child: const Text("Back To Home",
                                                    style: TextStyle(
                                                      color: Colors.blue,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                  );

                                }
                              }
                            } catch (error) {
                              print(error.toString());
                            }
                          }
                        }
                      },
                      child: const Text("Send Order"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
  Future<void> getAvailable(int book_id) async {
    await refInventory.child(book_id.toString())
        .once().then((DataSnapshot dataSnapshot) {
      if(dataSnapshot.exists) {
        setState(() {
          available = dataSnapshot.value['quantity'];
        });
      }
    });
  }
}



