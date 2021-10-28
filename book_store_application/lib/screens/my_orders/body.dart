import 'package:book_store_application/screens/cart/cart_screen.dart';
import 'package:book_store_application/screens/my_orders/order_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'order_card.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {

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
                  Tab(child: Text("Comfirm", style: TextStyle(color: Colors.black),),),
                  Tab(child: Text("Delivery",style: TextStyle(color: Colors.black),),),
                  Tab(child: Text("Placed",style: TextStyle(color: Colors.black),),),
                  Tab(child: Text("Cancelled",style: TextStyle(color: Colors.black),),),
                  ],
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: TabBarView(
                      children: [
                        OrderPlaceWidget(context, 0),
                        OrderPlaceWidget(context, 0),
                        OrderPlaceWidget(context, 0),
                        OrderPlaceWidget(context, 0),
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
  Widget OrderPlaceWidget(BuildContext context,int status) {
    // return FutureBuilder(
    //     future: //get order by status,
    //     builder: (context, snapshot){
    //       if(connect = waiting)
    //         return Center(child: CirularProgressIndicator(),);
    //       else{
    //         if (order = 0)
    //             return Center(child:Text("You have O order"));
    //         else
    //           return ListView.builder(
    //             itemCount: order.lenght;
    //             itemBuilder:(context,index){
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Dismissible(
                        key: Key("1"),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          setState(() {});
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
                        child: OrderCard(),
                  ));
  //           }
  //
  //             );
  //         }
  //       }
  //       );
   }
}
