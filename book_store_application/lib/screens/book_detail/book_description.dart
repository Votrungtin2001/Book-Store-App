import 'package:book_store_application/screens/book_detail/custom_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants.dart';

class BookDescription extends StatefulWidget {
  const BookDescription({Key? key, this.pressOnSeeMore,}) : super(key: key);
  final GestureTapCallback? pressOnSeeMore;

  _BookDescriptionState createState() => _BookDescriptionState();

}

class _BookDescriptionState extends State<BookDescription> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RichText(
                text: const TextSpan(
                  text: 'Name of Book\n',
                  style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(text: 'By author\n', style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black12,fontSize: 16)),
                    TextSpan(text: "\$200", style: TextStyle(fontWeight: FontWeight.w500,color: Colors.red,fontSize: 26)),
                  ],
                ),
              )
            ),
            Spacer(),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.all(12),
                width: 56,
                // decoration: const BoxDecoration(
                //   color: Colors.black12,
                //   borderRadius: BorderRadius.only(
                //     topLeft: Radius.circular(15),
                //     bottomLeft: Radius.circular(15),
                //   ),
                // ),
                child: SvgPicture.asset(
                  "assets/icons/heart.svg",
                  height: 24,
                ),
              ),
            ),

          ],
      ),
    );

  }

}