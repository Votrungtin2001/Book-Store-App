import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../size_config.dart';

class AddToCart extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // Now this is fixed and only for demo
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
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
          Spacer(),
          TextButton(
            style: TextButton.styleFrom(
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              primary: Colors.white,
              backgroundColor: Colors.blue,
            ),
            onPressed: (){},
            child: const Text(
              "Add To Cart",
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
