import 'package:book_store_application/screens/home/home_screen.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

final labels = [
  'Notifications',
  'Payments',
  'Message',
  'My Orders',
  'Setting Account',
  'Call Center',
  'About Application',
];

final icons = [
  Icons.notifications,
  Icons.payment,
  Icons.message,
  Icons.local_dining,
  Icons.settings,
  Icons.person,
  Icons.info,
];

class _BodyState extends State<Body> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            overflow: Overflow.visible,
            alignment: Alignment.center,
            children: [
              const SizedBox(
                height: 250.0,
                child: Image(
                  image: AssetImage("assets/images/img.png"),
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: -60.0,
                child: Container(
                  height: 125.0,
                  width: 125.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    border: Border.all(
                      color: Colors.white,
                      // width: wi,
                    ),
                    image: const DecorationImage(
                      image: AssetImage("assets/images/img.png"),
                    ),
                  ),
                ),
              ),
              const Positioned(
                bottom: -88.0,
                child: Text(
                  'Username',
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 88.0),
              itemCount: labels.length,
              itemBuilder: (context, index) {
                return ListTile(
                  // dense: true,
                    leading: Icon(
                      icons[index],
                      color: Colors.black,
                    ),
                    title: Text(labels[index]),
                    onTap: () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                          return HomeScreen();
                      // switch (labels[index]) {
                      //   case 'Notifications':
                      //     return NotificationList();
                      //     break;
                      //   case 'Payments':
                      //     return PaymentDetails();
                      //     break;
                      //   case 'Message':
                      //     return Message();
                      //     break;
                      //   case 'My Orders':
                      //     return TrackOrder();
                      //     break;
                      //   case 'Setting Account':
                      //     return Setting();
                      //     break;
                      //   case 'Call Center':
                      //     return CallCenter();
                      //   case 'About Application':
                      //     return About();
                      //     break;
                      //   default:
                      //     return null;
                      // }
                    }))
                  // onTap: () => this.setState(
                  //   () {
                  //     switch (labels[index]) {
                  //       case 'Notifications':
                  //         return snackBarMsg(context, 'Notifications');
                  //         break;
                  //       case 'Payments':
                  //         return snackBarMsg(context, 'Payments');
                  //         break;
                  //       case 'Message':
                  //         return snackBarMsg(context, 'Message');
                  //         break;
                  //       case 'My Orders':
                  //         return snackBarMsg(context, 'My Orders');
                  //         break;
                  //       case 'Setting Account':
                  //         return snackBarMsg(context, 'Setting Account');
                  //         break;
                  //       case 'Call Center':
                  //         return snackBarMsg(context, 'Call Center');
                  //         break;
                  //       case 'About Application':
                  //         return snackBarMsg(context, 'About Application');
                  //         break;
                  //       default:
                  //         return snackBarMsg(context, 'Notifications');
                  //         break;
                  //     }
                  //   },
                  // ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
