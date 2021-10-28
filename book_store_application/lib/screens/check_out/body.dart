import 'package:book_store_application/screens/change_address_screen.dart';
import 'package:book_store_application/screens/home/home_screen.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
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
                          RichText(
                            text: TextSpan(
                              text: 'Name of book',
                              style: DefaultTextStyle.of(context).style,
                              children: const <TextSpan>[
                                TextSpan(text: ' x', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                TextSpan(text: ' 2',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                              ],
                            ),
                          ),
                          Text(
                            "\$2",
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
                            "\$68",
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
                            "\$2",
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
                            "\$66",
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
                                "O dau con lau moi noi",
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
                              child: Text("78910JQK",
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
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
                      onPressed: () {
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
                                              builder: (BuildContext context) => HomeScreen(),
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
}



