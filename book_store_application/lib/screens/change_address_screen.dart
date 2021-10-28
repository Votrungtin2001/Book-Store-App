import 'package:book_store_application/screens/select_card_page.dart';
import 'package:flutter/material.dart';

class AddAddressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Widget finishButton = InkWell(
      onTap:() {},
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width / 1.5,
        decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [
              Color.fromRGBO(236, 60, 3, 1),
              Color.fromRGBO(234, 60, 3, 1),
              Color.fromRGBO(216, 78, 16, 1),],
                begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.16),
                offset: Offset(0, 5),
                blurRadius: 10.0,
              )
            ],
            borderRadius: BorderRadius.circular(9.0)),
        child: Center(
          child: Text("Finish",
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontSize: 20.0)
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.grey),
        title: Text(
          'Add Address',
          style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
              fontSize: 18.0),
        ),
      ),
      body: LayoutBuilder(
        builder: (_, viewportConstraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
            BoxConstraints(minHeight: viewportConstraints.maxHeight),
            child: Container(
              padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: MediaQuery.of(context).padding.bottom == 0
                      ? 20
                      : MediaQuery.of(context).padding.bottom),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          color: Colors.white,
                          elevation: 3,
                          child: SizedBox(
                              height: 100,
                              width: 80,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Image.asset(
                                          'assets/icons/address_home.png'),
                                    ),
                                    Text(
                                      'Add New Address',
                                      style: TextStyle(
                                        fontSize: 8,
                                        color: Colors.grey,
                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ))),
                      Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          color: Colors.blue,
                          elevation: 3,
                          child: SizedBox(
                              height: 80,
                              width: 100,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Image.asset(
                                        'assets/icons/address_home.png',
                                        color: Colors.white,
                                        height: 20,
                                      ),
                                    ),
                                    Text(
                                      'Simon Philip,\nCity Oscarlad',
                                      style: TextStyle(
                                        fontSize: 8,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ))),
                      Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          color: Colors.blue,
                          elevation: 3,
                          child: SizedBox(
                              height: 80,
                              width: 100,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Image.asset(
                                          'assets/icons/address_work.png',
                                          color: Colors.white,
                                          height: 20),
                                    ),
                                    Text(
                                      'Workplace',
                                      style: TextStyle(
                                        fontSize: 8,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              )))
                    ],
                  ),
                SizedBox(
                  height: 500,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.white,
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: 'Flat Number/House Number'),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.white,
                        ),
                        child: TextField(
                          decoration:
                          InputDecoration(border: InputBorder.none, hintText: 'Street'),
                        ),
                      ),
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: <Widget>[
                      //     Padding(
                      //       padding: const EdgeInsets.all(16.0),
                      //       child: Text(
                      //         'Area',
                      //         style: TextStyle(fontSize: 12, color: Colors.grey),
                      //       ),
                      //     ),
                      //     ClipRRect(
                      //       borderRadius: BorderRadius.only(
                      //           topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                      //       child: Container(
                      //         padding: EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                      //         decoration: BoxDecoration(
                      //           border: Border(
                      //               bottom: BorderSide(color: Colors.orange, width: 2)),
                      //           color: Colors.orange[100],
                      //         ),
                      //         child: TextField(
                      //           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      //           decoration: InputDecoration(
                      //             border: InputBorder.none,
                      //             hintText: 'Name on card',
                      //             hintStyle:
                      //             TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // Container(
                      //   padding: EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.all(Radius.circular(5)),
                      //     color: Colors.white,
                      //   ),
                      //   child: TextField(
                      //     decoration: InputDecoration(
                      //         border: InputBorder.none, hintText: 'Name on card'),
                      //   ),
                      // ),
                      // ClipRRect(
                      //   borderRadius: BorderRadius.only(
                      //       topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                      //   child: Container(
                      //     padding: EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                      //     decoration: BoxDecoration(
                      //       border: Border(bottom: BorderSide(color: Colors.red, width: 1)),
                      //       color: Colors.white,
                      //     ),
                      //     child: TextField(
                      //       decoration: InputDecoration(
                      //           border: InputBorder.none, hintText: 'Postal code'),
                      //     ),
                      //   ),
                      // ),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: true,
                            onChanged: (_) {},
                          ),
                          Text('Add this to address bookmark')
                        ],
                      )
                    ],
                  ),
                ),
                  Center(child: finishButton)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}