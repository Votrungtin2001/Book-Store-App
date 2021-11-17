import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:async';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  List<Asset> images = [];
  File? image;
  String? filename;

  Future<void> pickImages() async {
    List<Asset> resultList = [];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 3,
        enableCamera: true,
        selectedAssets: images,
        materialOptions: MaterialOptions(
          actionBarTitle: "FlutterCorner.com",
        ),
      );
    } on Exception catch (e) {
      print(e);
    }

    setState(() {
      images = resultList;
    });
  }

  @override
  Widget build(BuildContext context) {

    String? dropdownValue = 'First';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Row(
                    children: const [
                      Icon(
                        Icons.navigate_before, color: Colors.black, size: 35,),
                      Text("Back", style: TextStyle(color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w400),)
                    ],
                  ),
                  onPressed: () { Navigator.pop(context);},
                ),

              ],
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // SizedBox(height: 30),
              //
              // SizedBox(height: 8),
              Container(
                // height: MediaQuery.of(context).size.height - 170,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Text("Id book"),
                      Container(
                        padding: EdgeInsets.only( top: 4.0, bottom: 4.0),
                        child: TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
                              fillColor: Colors.transparent,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(color: Colors.black)
                              ),
                              filled: true,
                              hintStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
                              hintText: 'Id book'
                          ),
                        ),
                      ),

                      Text("Title"),
                      Container(
                        padding: EdgeInsets.only( top: 4.0, bottom: 4.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
                              fillColor: Colors.transparent,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(color: Colors.black)
                              ),
                              filled: true,
                              hintStyle: const TextStyle(color: Colors.black38),
                              hintText: 'Title'
                          ),
                        ),
                      ),

                      Text("Category"), //combobox
                      Padding(
                          padding: EdgeInsets.only( top: 4.0, bottom: 4.0),
                          child: Container(
                              padding: EdgeInsets.only(left:10,right:10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.circular(15.0),
                              ) ,
                              child: DropdownButton<String>(
                                hint: Text("Select: "),
                                dropdownColor: Colors.white,
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 36,
                                isExpanded: true,
                                style: TextStyle(
                                  color:Colors.black38,
                                  fontSize: 16,
                                ),
                                underline: SizedBox(

                                ),
                                value: dropdownValue,
                                onChanged: (String? newValue) {
                                  setState(
                                          () {
                                        dropdownValue = newValue;
                                      }
                                  );
                                },
                                items: <String>['First', 'Second', 'Third', 'Fourth']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              )
                          )
                      ),

                      Text("Genre"),
                      Container(
                        padding: EdgeInsets.only( top: 4.0, bottom: 4.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
                              fillColor: Colors.transparent,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(color: Colors.black)
                              ),
                              filled: true,
                              hintStyle: const TextStyle(color: Colors.black38),
                              hintText: 'Genre'),
                        ),
                      ),

                      Text("Author"),
                      Padding(
                          padding: EdgeInsets.only( top: 4.0, bottom: 4.0),
                          child: Container(
                              padding: EdgeInsets.only(left:10,right:10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.circular(15.0),
                              ) ,
                              child: DropdownButton<String>(
                                hint: Text("Select: "),
                                dropdownColor: Colors.white,
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 36,
                                isExpanded: true,
                                style: TextStyle(
                                  color:Colors.black38,
                                  fontSize: 16,
                                ),
                                underline: SizedBox(),
                                value: dropdownValue,
                                onChanged: (String? newValue) {
                                  setState(
                                          () {
                                        dropdownValue = newValue;
                                      }
                                  );
                                },
                                items: <String>['First', 'Second', 'Third', 'Fourth']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              )
                          )
                      ),

                      Text("Publisher"),
                      Padding(
                          padding: EdgeInsets.only( top: 4.0, bottom: 4.0),
                          child: Container(
                              padding: EdgeInsets.only(left:10,right:10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.circular(15.0),
                              ) ,
                              child: DropdownButton<String>(
                                hint: Text("Select: "),
                                dropdownColor: Colors.white,
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 36,
                                isExpanded: true,
                                style: TextStyle(
                                  color:Colors.black38,
                                  fontSize: 16,
                                ),
                                underline: SizedBox(),
                                value: dropdownValue,
                                onChanged: (String? newValue) {
                                  setState(
                                          () {
                                        dropdownValue = newValue;
                                      }
                                  );
                                },
                                items: <String>['First', 'Second', 'Third', 'Fourth']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              )
                          )
                      ),

                      Text("Publisher Year"),
                      Container(
                        padding: EdgeInsets.only( top: 4.0, bottom: 4.0),
                        child: TextFormField(
                          keyboardType:TextInputType.number,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
                              fillColor: Colors.transparent,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(color: Colors.black)
                              ),
                              filled: true,
                              hintStyle: const TextStyle(color: Colors.black38),
                              hintText: 'Avaiable'),
                        ),
                      ),

                      Text("Price"),
                      Container(
                        padding: EdgeInsets.only( top: 4.0, bottom: 4.0),
                        child: TextFormField(
                          keyboardType:TextInputType.number,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
                              fillColor: Colors.transparent,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(color: Colors.black)
                              ),
                              filled: true,
                              hintStyle: const TextStyle(color: Colors.black38),
                              hintText: 'Price'),
                        ),
                      ),

                      Text("Available"),
                      Container(
                        padding: EdgeInsets.only( top: 4.0, bottom: 4.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
                              fillColor: Colors.transparent,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(color: Colors.black)
                              ),
                              filled: true,
                              hintStyle: const TextStyle(color: Colors.black38),
                              hintText: 'Avaiable'),
                        ),
                      ),
                      Text("Sold"),
                      Container(
                        padding: EdgeInsets.only( top: 4.0, bottom: 4.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          readOnly: true,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
                              fillColor: Colors.transparent,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(color: Colors.black)
                              ),
                              filled: true,
                              hintStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
                              hintText: 'Sold'
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Container(
                        height: 220,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              OutlineButton(
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                onPressed: pickImages,
                                child: Text("Pick images",
                                    style: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 2.2,
                                        color: Colors.black)
                                ),
                              ),
                              Expanded(
                                child: GridView.count(
                                  scrollDirection: Axis.vertical,
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10,
                                  children: List.generate(images.length, (index) {
                                    Asset asset = images[index];
                                    return AssetThumb(
                                      asset: asset,
                                      width: 300,
                                      height: 300,
                                    );
                                  }
                                  ),
                                ),
                              ),
                            ]
                        ),
                      ),
                      Text("Desciption"),
                      Container(
                        padding: EdgeInsets.only( top: 4.0, bottom: 4.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 100.0,horizontal: 10.0),
                              fillColor: Colors.transparent,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(color: Colors.black)
                              ),
                              filled: true,
                              hintStyle: const TextStyle(color: Colors.black38,),
                              hintText: 'Desciption'
                          ),
                        ),
                      ),
                      // const SizedBox(height: 10,),
                      Center(
                          child: RaisedButton(
                            color: Colors.blue,
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 2.2,
                                  color: Colors.white),
                            ),
                            onPressed: () {  },
                          )
                      )
                    ],
                  ),
                ),

              ),

            ],
          ),
        ),
      ),
    );


  }


}

class Complete extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                "Event created successfully",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 25,
                ),
              ),
            ),
            SizedBox(height: 10),
            Icon(
              Icons.check_circle_outline_outlined,
              color: Colors.green,
              size: 60,
            ),
          ],
        ),
      ),
    );
  }

}



