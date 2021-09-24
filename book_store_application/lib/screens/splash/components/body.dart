import 'package:flutter/material.dart';
import 'package:book_store_application/screens/splash/components/content_model.dart';
import 'package:book_store_application/screens/start/start_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Column(
        children: <Widget>[
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: contents.length,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, i) {
                return Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      const Spacer(flex: 3,),
                      SvgPicture.asset(
                        contents[i].image,
                        height: 314,
                        width: 237,
                      ),
                      const Spacer(flex: 3,),
                      Text(
                        contents[i].title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Text(
                        contents[i].discription,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            height: 60,
            margin: const EdgeInsets.all(40),
            width: 150,
            child: FlatButton(
              child: Text(
                  currentIndex == contents.length - 1 ? "Get Start" : "Next"),
              onPressed: () {
                if (currentIndex == contents.length - 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StartScreen(),
                    ),
                  );
                }
                _controller.nextPage(
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.bounceIn,
                );
              },
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 20,),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                contents.length,
                    (index) => buildDot(index, context),
              ),
            ),
          ),
          const SizedBox(height: 20,),
        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 30 : 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
          color: (index == currentIndex) ? Colors.blue : Colors.blue.withOpacity(0.5)));
  }
}

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key? key, required this.child,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
    height: size.height ,
    width:double.infinity ,
    child: Stack(
      alignment: Alignment.center,
      children:  <Widget>[
        Positioned(
            child: Image.asset("assets/images/img.png",
                height: size.height,
                width: size.width,
                fit:BoxFit.cover
            )
        ),
        child,
      ],
    )
      );
  }
}