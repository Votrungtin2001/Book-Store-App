import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DestinationCarousel extends StatefulWidget {
  const DestinationCarousel({required key}) : super(key: key);

  @override
  _DestinationCarouselState createState() => _DestinationCarouselState();
}

class _DestinationCarouselState extends State<DestinationCarousel> {

  @override
  Widget build(BuildContext context) {
     return Shimmer.fromColors(
      highlightColor: Colors.white,
      baseColor: Colors.grey[300]!,
      child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: AspectRatio(
                  aspectRatio: 3/1,
                  child: Container(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,

                children:[
                  Container(
                    height: 8,
                    width: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 5,),
                  Container(
                    height: 8,
                    width: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 5,),
                  Container(
                    height: 8,
                    width: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 5,),
                  Container(
                    height: 8,
                    width: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 5,),
                  Container(
                    height: 8,
                    width: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 5,)
                ]
            )
          ]
      )
      );
  }
}
