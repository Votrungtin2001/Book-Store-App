import 'package:book_store_application/MVP/Model/Author.dart';
import 'package:book_store_application/MVP/Model/Book.dart';
import 'package:book_store_application/MVP/Model/Category.dart';
import 'package:book_store_application/MVP/Model/Publisher.dart';
import 'package:book_store_application/firebase/providers/author_provider.dart';
import 'package:book_store_application/firebase/providers/books_provider.dart';
import 'package:book_store_application/firebase/providers/category_provider.dart';
import 'package:book_store_application/firebase/providers/publisher_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:async';

import 'package:provider/provider.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Body extends StatefulWidget {
  Book? book;
  String? category;
  String? author;
  String? publisher;

  Body(Book? book, String? category, String? author, String? publisher) {
    this.book = book;
    this.category = category;
    this.author = author;
    this.publisher = publisher;
  }

  @override
  _BodyState createState() => _BodyState(this.book, this.category, this.author, this.publisher);
}

class _BodyState extends State<Body> {

  List<Asset> images = [];
  File? image;
  String? filename;
  List<File> fileImageArray = [];

  Book? book;

  final formKey = GlobalKey<FormState>();

  List<Book> books = [];
  int selectedIDBook = 0;

  String title = "";
  TextEditingController _titleController = TextEditingController();

  List<Category> categories = [];
  int selectedIDCategory = 1;
  String selectedNameCategory = '';

  String genre = "";
  TextEditingController _genreController = TextEditingController();

  List<Author> authors = [];
  int selectedIDAuthor = 1;
  String selectedNameAuthor = '';

  List<Publisher> publishers = [];
  int selectedIDPublisher = 1;
  String selectedNamePublisher = '';

  String publishing_year = "";
  TextEditingController _publishingYearController = TextEditingController();

  String price = "";
  TextEditingController _priceController = TextEditingController();

  String available = "";
  TextEditingController _availableController = TextEditingController();

  String sold_count = "";
  TextEditingController _soldCountController = TextEditingController();

  String summary = "";
  TextEditingController _summaryController = TextEditingController();

  int iAvailable = 0;
  final DatabaseReference refInventory = FirebaseDatabase.instance.reference().child('Inventory');

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String collection = "Books";

  _BodyState(Book? book, String? category, String? author, String? publisher) {
    this.book = book;
    this.selectedNameCategory = category.toString();
    this.selectedNameAuthor = author.toString();
    this.selectedNamePublisher = publisher.toString();
  }

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
      fileImageArray = convertAssetListToFileList(resultList);
    });
  }

  @override
  Widget build(BuildContext context) {
    selectedIDBook = book!.getID();
    selectedIDCategory = book!.getCATEGORY_ID();
    selectedIDAuthor = book!.getAUTHOR_ID();
    selectedIDPublisher = book!.getPUBLISHER_ID();

    int int_price = book!.getPRICE().round();


    final categoryProvider = Provider.of<CategoryProvider>(context);
    categories = categoryProvider.categories;

    final authorProvider = Provider.of<AuthorProvider>(context);
    authors = authorProvider.authors;

    final publisherProvider = Provider.of<PublisherProvider>(context);
    publishers = publisherProvider.publishers;

    final booksProvider = Provider.of<BooksProvider>(context);

    getQuantity(book!.getID());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
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
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height,
          maxWidth: MediaQuery.of(context).size.width,
        ),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg2.png"),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 15),
        height: double.infinity,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              SizedBox(height: 80),

              Container(
                // height: MediaQuery.of(context).size.height - 170,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Form(
                    key: formKey,
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
                              hintText: selectedIDBook.toString(),
                            ),
                          ),
                        ),
                        Text("Title"),
                        Container(
                          padding: EdgeInsets.only( top: 4.0, bottom: 4.0),
                          child: TextFormField(
                            controller: _titleController,
                            onChanged: (value) {
                              setState(() {
                                title = value;
                              });
                            },
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
                                fillColor: Colors.transparent,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: const BorderSide(color: Colors.black)
                                ),
                                filled: true,
                                hintStyle: const TextStyle(color: Colors.black38),
                                hintText: book!.getTITLE(),
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
                                  value: selectedNameCategory,
                                  onChanged: (String? newValue) {
                                    setState(
                                            () {
                                              selectedNameCategory = newValue.toString();
                                        }
                                    );
                                  },
                                  items: categories
                                      .map<DropdownMenuItem<String>>((Category category) {
                                    return DropdownMenuItem<String>(
                                      value: category.getNAME(),
                                      child: Text(category.getNAME()),
                                    );
                                  }).toList(),
                                )
                            )
                        ),

                        Text("Genre"),
                        Container(
                          padding: EdgeInsets.only( top: 4.0, bottom: 4.0),
                          child: TextFormField(
                            controller: _genreController,
                            onChanged: (value) {
                              setState(() {
                                genre = value;
                              });
                            },
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
                                fillColor: Colors.transparent,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: const BorderSide(color: Colors.black)
                                ),
                                filled: true,
                                hintStyle: const TextStyle(color: Colors.black38),
                                hintText: book!.getGENRE()),
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
                                  hint: Text("Select"),
                                  dropdownColor: Colors.white,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 36,
                                  isExpanded: true,
                                  style: TextStyle(
                                    color:Colors.black38,
                                    fontSize: 16,
                                  ),
                                  underline: SizedBox(),
                                  value: selectedNameAuthor,
                                  onChanged: (String? newValue) {
                                    setState(
                                            () {
                                              selectedNameAuthor = newValue.toString();
                                        }
                                    );
                                  },
                                  items: authors
                                      .map<DropdownMenuItem<String>>((Author author) {
                                    return DropdownMenuItem<String>(
                                      value: author.getNAME(),
                                      child: Text(author.getNAME()),
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
                                  hint: Text("Select"),
                                  dropdownColor: Colors.white,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 36,
                                  isExpanded: true,
                                  style: TextStyle(
                                    color:Colors.black38,
                                    fontSize: 16,
                                  ),
                                  underline: SizedBox(),
                                  value: selectedNamePublisher,
                                  onChanged: (String? newValue) {
                                    setState(
                                            () {
                                              selectedNamePublisher = newValue.toString();
                                        }
                                    );
                                  },
                                  items: publishers
                                      .map<DropdownMenuItem<String>>((Publisher publisher) {
                                    return DropdownMenuItem<String>(
                                      value: publisher.getNAME(),
                                      child: Text(publisher.getNAME()),
                                    );
                                  }).toList(),
                                )
                            )
                        ),

                        Text("Publisher Year"),
                        Container(
                          padding: EdgeInsets.only( top: 4.0, bottom: 4.0),
                          child: TextFormField(
                            controller: _publishingYearController,
                            onChanged: (value) {
                              setState(() {
                                publishing_year = value;
                              });
                            },
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
                                hintText: book!.getPUBLISHING_YEAR().toString()),
                          ),
                        ),

                        Text("Price"),
                        Container(
                          padding: EdgeInsets.only( top: 4.0, bottom: 4.0),
                          child: TextFormField(
                            controller: _priceController,
                            onChanged: (value) {
                              setState(() {
                                price = value;
                              });
                            },
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
                                hintText: int_price.toString()),
                          ),
                        ),

                        Text("Available"),
                        Container(
                          padding: EdgeInsets.only( top: 4.0, bottom: 4.0),
                          child: TextFormField(
                            controller: _availableController,
                            onChanged: (value) {
                              setState(() {
                                available = value;
                              });
                            },
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
                                hintText: iAvailable.toString()),
                          ),
                        ),
                        Text("Sold"),
                        Container(
                          padding: EdgeInsets.only( top: 4.0, bottom: 4.0),
                          child: TextFormField(
                            controller: _soldCountController,
                            onChanged: (value) {
                              setState(() {
                                sold_count = value;
                              });
                            },
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
                                hintText: book!.getSOLD_COUNT().toString(),
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
                            controller: _summaryController,
                            onChanged: (value) {
                              setState(() {
                                summary = value;
                              });
                            },
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(vertical: 100.0,horizontal: 10.0),
                                fillColor: Colors.transparent,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: const BorderSide(color: Colors.black)
                                ),
                                filled: true,
                                hintStyle: const TextStyle(color: Colors.black38,),
                                hintText: book!.getSUMMARY().toString(),
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
                              onPressed: () async {
                                EasyLoading.show(status: 'Updating this book...');
                                selectedIDCategory = getIDCategory(selectedNameCategory);
                                selectedIDAuthor = getIDAuthor(selectedNameAuthor);
                                selectedIDPublisher = getIDPublisher(selectedNamePublisher);

                                if(title != "") {
                                  _firestore.collection(collection).doc(selectedIDBook.toString()).update({'title': title});
                                  booksProvider.updateTitle(selectedIDBook, title);
                                }
                                if(selectedIDCategory > 0) {
                                  _firestore.collection(collection).doc(selectedIDBook.toString()).update
                                    ({'category_id': selectedIDCategory, 'author_id': selectedIDAuthor, 'publisher_id': selectedIDPublisher});
                                  booksProvider.updateCategory_Author_Publisher(selectedIDBook, selectedIDCategory, selectedIDAuthor, selectedIDPublisher);
                                }
                                if(genre != "") {
                                  _firestore.collection(collection).doc(selectedIDBook.toString()).update({'genre': genre});
                                  booksProvider.updateGenre(selectedIDBook, genre);
                                }
                                if(publishing_year != "") {
                                  int iPublishing_Year = int.parse(publishing_year);
                                  _firestore.collection(collection).doc(selectedIDBook.toString()).update({'publishing_year': iPublishing_Year});
                                  booksProvider.updatePublishing_Year(selectedIDBook, iPublishing_Year);
                                }

                                if(price != "") {
                                  int iPrice = int.parse(price);
                                  double dPrice = double.parse(price);
                                  _firestore.collection(collection).doc(selectedIDBook.toString()).update({'price': iPrice});
                                  booksProvider.updatePrice(selectedIDBook, dPrice);
                                }
                                if(available != "") {
                                  int iAvailable = int.parse(available);
                                  refInventory.child(selectedIDBook.toString())
                                      .update({'quantity': iAvailable});
                                }
                                if(summary != "") {
                                  _firestore.collection(collection).doc(selectedIDBook.toString()).update({'summary': summary});
                                  booksProvider.updateSummary(selectedIDBook, summary);
                                }

                                if(fileImageArray.length > 0) {
                                  int booksLength = books.length;
                                  firebase_storage.FirebaseStorage storage =
                                      firebase_storage.FirebaseStorage.instance;
                                  await _firestore.collection(collection).doc(selectedIDBook.toString()).update({'image_url': []});

                                  String no_image1 = "https://firebasestorage.googleapis.com/v0/b/book-store-app-3d8a6.appspot.com/o/no_image.jpg?alt=media&token=c607c944-0b3c-425b-adb9-0c972623bf56";
                                  String no_image2 = "https://firebasestorage.googleapis.com/v0/b/book-store-app-3d8a6.appspot.com/o/no_image2.jpg?alt=media&token=f214bf93-91ac-4d69-b885-5cc73970b020";

                                  if(fileImageArray.length == 1) {
                                    firebase_storage.Reference ref = storage.ref().child(fileImageArray[0].path);
                                    firebase_storage.UploadTask uploadTask = ref.putFile(fileImageArray[0]);
                                    await uploadTask.whenComplete(() async {
                                      String url = await ref.getDownloadURL();
                                      if(url != "") {
                                        await _firestore.collection(collection).doc(selectedIDBook.toString()).update({'image_url': FieldValue.arrayUnion([url])});
                                        await _firestore.collection(collection).doc(selectedIDBook.toString()).update({'image_url': FieldValue.arrayUnion([no_image1])});
                                        await _firestore.collection(collection).doc(selectedIDBook.toString()).update({'image_url': FieldValue.arrayUnion([no_image2])});
                                        List<String> image_url = [];
                                        image_url.add(url);
                                        image_url.add(no_image1);
                                        image_url.add(no_image2);
                                        booksProvider.updateImageUrl(selectedIDBook, image_url);
                                        finish();
                                        Navigator.of(context).pop();
                                      }
                                    });
                                  }

                                  else if(fileImageArray.length == 2) {

                                    List<String> image_url = [];
                                    firebase_storage.Reference ref1 = storage.ref().child(fileImageArray[0].path);
                                    firebase_storage.UploadTask uploadTask1 = ref1.putFile(fileImageArray[0]);
                                    await uploadTask1.whenComplete(() async {
                                      String url1 = await ref1.getDownloadURL();
                                      if(url1 != "") {
                                        await _firestore.collection(collection).doc(selectedIDBook.toString()).update({'image_url': FieldValue.arrayUnion([url1])});
                                        image_url.add(url1);
                                      }
                                    });

                                    firebase_storage.Reference ref2 = storage.ref().child(fileImageArray[1].path);
                                    firebase_storage.UploadTask uploadTask2 = ref2.putFile(fileImageArray[1]);
                                    await uploadTask2.whenComplete(() async {
                                      String url2 = await ref2.getDownloadURL();
                                      if(url2 != "") {
                                        await _firestore.collection(collection).doc(selectedIDBook.toString()).update({'image_url': FieldValue.arrayUnion([url2])});
                                        await _firestore.collection(collection).doc(selectedIDBook.toString()).update({'image_url': FieldValue.arrayUnion([no_image1])});
                                        image_url.add(url2);
                                        image_url.add(no_image1);
                                        booksProvider.updateImageUrl(selectedIDBook, image_url);
                                        finish();
                                        Navigator.of(context).pop();

                                      }
                                    });
                                  }

                                  else if(fileImageArray.length == 3) {
                                    List<String> image_url = [];
                                    firebase_storage.Reference ref1 = storage.ref().child(fileImageArray[0].path);
                                    firebase_storage.UploadTask uploadTask1 = ref1.putFile(fileImageArray[0]);
                                    await uploadTask1.whenComplete(() async {
                                      String url1 = await ref1.getDownloadURL();
                                      if(url1 != "") {
                                        await _firestore.collection(collection).doc(selectedIDBook.toString()).update({'image_url': FieldValue.arrayUnion([url1])});
                                        image_url.add(url1);
                                      }
                                    });

                                    firebase_storage.Reference ref2 = storage.ref().child(fileImageArray[1].path);
                                    firebase_storage.UploadTask uploadTask2 = ref2.putFile(fileImageArray[1]);
                                    await uploadTask2.whenComplete(() async {
                                      String url2 = await ref2.getDownloadURL();
                                      if(url2 != "") {
                                        await _firestore.collection(collection).doc(selectedIDBook.toString()).update({'image_url': FieldValue.arrayUnion([url2])});
                                        image_url.add(url2);
                                      }
                                    });

                                    firebase_storage.Reference ref3 = storage.ref().child(fileImageArray[2].path);
                                    firebase_storage.UploadTask uploadTask3 = ref3.putFile(fileImageArray[2]);
                                    await uploadTask3.whenComplete(() async {
                                      String url3 = await ref3.getDownloadURL();
                                      if(url3 != "") {
                                        await _firestore.collection(collection).doc(selectedIDBook.toString()).update({'image_url': FieldValue.arrayUnion([url3])});
                                        image_url.add(url3);

                                        booksProvider.updateImageUrl(selectedIDBook, image_url);
                                        finish();
                                        Navigator.of(context).pop();
                                      }
                                    });
                                  }

                                }
                                else {
                                  finish();
                                  Navigator.of(context).pop();
                                }

                              },
                            )
                        )
                      ],
                    ),
                  ),
                  ),


              ),

            ],
          ),
        ),
      ),
    );


  }

  String getCategoryName(int category_id) {
    for(int i = 0; i < categories.length; i++) {
      if(categories[i].getID() == category_id) {
        return categories[i].getNAME();
      }
    }
    return "";
  }

  int getIDCategory(String name) {
    for(int i = 0; i < categories.length; i++) {
      if(name == categories[i].getNAME()) return categories[i].getID();
    }
    return 0;
  }

  String getAuthorName(int author_id) {
    for(int i = 0; i < authors.length; i++) {
      if(authors[i].getID() == author_id) {
        return authors[i].getNAME();
      }
    }
    return "";
  }

  int getIDAuthor(String name) {
    for(int i = 0; i < authors.length; i++) {
      if(name == authors[i].getNAME()) return authors[i].getID();
    }
    return 0;
  }

  String getPublisherName(int publisher_id) {
    for(int i = 0; i < publishers.length; i++) {
      if(publishers[i].getID() == publisher_id) {
        return publishers[i].getNAME();
      }
    }
    return "";
  }

  int getIDPublisher(String name) {
    for(int i = 0; i < publishers.length; i++) {
      if(name == publishers[i].getNAME()) return publishers[i].getID();
    }
    return 0;
  }

  void getQuantity(int book_id) {
    refInventory.child(book_id.toString())
        .once().then((DataSnapshot dataSnapshot) {
      if(dataSnapshot.exists) {
        setState(() {
          iAvailable = dataSnapshot.value['quantity'];
        });
      }
    });
  }

  List<File> convertAssetListToFileList(List<Asset> assets) {
    List<File> files = [];
    assets.forEach((imageAsset) async {
      final filePath =
      await FlutterAbsolutePath.getAbsolutePath(imageAsset.identifier);

      File tempFile = File(filePath);

      if (tempFile.existsSync()) {
        files.add(tempFile);
      }
    });
    return files;
  }

  void finish() {
    _genreController.clear();
    _publishingYearController.clear();
    _priceController.clear();
    _availableController.clear();
    _titleController.clear();
    _summaryController.clear();
    _soldCountController.clear();
    genre = "";
    publishing_year = "";
    price = "";
    available = "";
    title = "";
    summary = "";
    setState(() {
      fileImageArray = [];
      images = [];
    });
    EasyLoading.showSuccess('Updated this book successfully');
    Future.delayed(const Duration(milliseconds: 1000), () {
      EasyLoading.dismiss();
    });

  }


}
