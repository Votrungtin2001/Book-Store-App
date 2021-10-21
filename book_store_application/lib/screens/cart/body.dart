import 'package:book_store_application/firebase/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'cart_card.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      body: Column(
        children: [
         // getAppBarUI(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                itemCount: orderProvider.booksInCart.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Dismissible(
                    key: Key("1"),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      setState(() {
                        // code remove item
                      });
                    },
                    background: Container(
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
                    child: CartCard(orderProvider.booksInCart[index]),
                  ),
                ),
              ),
            ),
          )
        ],
      ) ,
    );
  }

  // Widget getAppBarUI() {
  //   return Container(
  //     decoration: const BoxDecoration(
  //       color: Colors.transparent,
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.only(top: 2, left: 8, right: 8),
  //       child: Row(
  //         children: <Widget>[
  //           Container(
  //             alignment: Alignment.centerLeft,
  //             width: AppBar().preferredSize.height + 40,
  //             height: AppBar().preferredSize.height,
  //             child: Material(
  //               color: Colors.transparent,
  //               child: InkWell(
  //                 borderRadius: const BorderRadius.all(Radius.circular(32.0),),
  //                 child: Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: TextButton(
  //                       child: Row(
  //                         children: const [
  //                           Icon(
  //                             Icons.navigate_before, color: Colors.black, size: 25,),
  //                           Text("Back", style: TextStyle(color: Colors.black,
  //                               fontSize: 15,
  //                               fontWeight: FontWeight.w400),)
  //                         ],
  //                       ),
  //                       onPressed: () { Navigator.pop(context);},
  //                     )
  //                 ),
  //               ),
  //             ),
  //           ),
  //           const Expanded(
  //             child: Center(
  //               child: Text(
  //                 'Cart',
  //                 style: TextStyle(
  //                   fontWeight: FontWeight.w700,
  //                   fontSize: 18,
  //
  //                 ),
  //               ),
  //             ),
  //           ),
  //
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
