import 'package:book_store_application/screens/book_detail/top_rounded_container.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import 'book_description.dart';
import 'book_image.dart';
import 'add_to_cart.dart';
import 'custom_tab_bar.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        getAppBarUI(),
        BookImages(),
        TopRoundedContainer(
          color: Colors.white,
          child: Column(
            children: [
              BookDescription(),
              TopRoundedContainer(
                color: const Color(0xFFF6F7F9),
                child: Column(
                  children: [
                   CustomTabBar(),
                    TopRoundedContainer(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10, top: 10,),
                        child: AddToCart(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget getAppBarUI() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 2, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(32.0),),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      child: Row(
                        children: const [
                          Icon(
                            Icons.navigate_before, color: Colors.black, size: 25,),
                          Text("Back", style: TextStyle(color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),)
                        ],
                      ),
                      onPressed: () { Navigator.pop(context);},
                    )
                  ),
                ),
              ),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'Book Detail',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,

                  ),
                ),
              ),
            ),
            SizedBox(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                      onTap: () {},
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon( Icons.shopping_bag_outlined ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}



