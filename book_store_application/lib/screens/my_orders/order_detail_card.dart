import 'package:flutter/material.dart';

class OrderDetailCard extends StatefulWidget {
  const OrderDetailCard({Key? key}) : super(key: key);

  @override
  _OrderDetailCardState createState() => _OrderDetailCardState();
}

class _OrderDetailCardState extends State<OrderDetailCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: AspectRatio(
              aspectRatio: 0.88,
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  //color: Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.asset("assets/images/img_2.png", fit: BoxFit.fitHeight,),
              ),
            ),
          ),
          SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "book.getTITLE()",
                  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 2,
                ),
                Text(
                  "getAuthorName(book.getAUTHOR_ID())",
                  style: TextStyle(color: Colors.black12, fontSize: 14),
                ),
                SizedBox(height: 10,),
                Text("currencyformat.format(book.getPRICE()) + d"),
              ],
            ),
          )
        ],
      ) ,
    );
  }
}
