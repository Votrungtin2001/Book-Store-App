import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../size_config.dart';

List<String> images = [
  "assets/images/img_2.png",
  "assets/images/img.png",
  "assets/images/bg2.png",
];

class BookImages extends StatefulWidget {
  @override
  _BookImagesState createState() => _BookImagesState();
}

class _BookImagesState extends State<BookImages> {
  int selectedImage = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 270,
          child: AspectRatio(
            aspectRatio: 1,
            child: Hero(
              tag: "",
              child: Image.asset(images[selectedImage]),
            ),
          ),
        ),
        // SizedBox(height: getProportionateScreenWidth(20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(images.length,
                    (index) => buildSmallBookPreview(index)),
          ],
        )
      ],
    );
  }

  GestureDetector buildSmallBookPreview(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = index;
        });
      },
      child: AnimatedContainer(
        duration: defaultDuration,
        margin: const EdgeInsets.only(right: 15, top: 8),
        padding: const EdgeInsets.all(8),
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: kPrimaryColor.withOpacity(selectedImage == index ? 1 : 0)),
        ),
        child: Image.asset(images[index]),
      ),
    );
  }
}