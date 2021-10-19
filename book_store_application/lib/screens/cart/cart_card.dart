import 'package:flutter/material.dart';

import '../../../constants.dart';


class CartCard extends StatelessWidget {
  // final Cart cart;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 88,
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Color(0xFFF5F6F9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset("assets/images/img_2.png"),
            ),
          ),
        ),
        SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Title",
              style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold),
              maxLines: 2,
            ),
            Text(
              "by author",
              style: TextStyle(color: Colors.black12, fontSize: 14),
            ),
            Row(
              children: [
                Text("2000"),
                SizedBox(width: 120,),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 10),
                    const Text("0"),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}