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
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:async';

import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  List<Asset> images = [];
  List<File> fileImageArray = [];

  final CollectionReference Books =
  FirebaseFirestore.instance.collection('Books');
  Book book_created = new Book(0, 0, 0, "", [], 0,
      0, 0, 0, "", "");

  String? dropdownValue = 'First';

  List<Book> books = [];
  int newIDBook = 0;

  List<Category> categories = [];
  int selectedIDCategory = 1;
  String selectedNameCategory = 'Novel';

  final formKey = GlobalKey<FormState>();
  String genre = "";
  TextEditingController _genreController = TextEditingController();

  List<Author> authors = [];
  int selectedIDAuthor = 1;
  String selectedNameAuthor = 'Andersen';

  List<Publisher> publishers = [];
  int selectedIDPublisher = 1;
  String selectedNamePublisher = 'Kim Dong Publisher';

  String publishing_year = "";
  TextEditingController _publishingYearController = TextEditingController();

  String price = "";
  TextEditingController _priceController = TextEditingController();

  String available = "";
  TextEditingController _availableController = TextEditingController();

  String title = "";
  TextEditingController _titleController = TextEditingController();

  String summary = "";
  TextEditingController _summaryController = TextEditingController();

  final DatabaseReference refInventory = FirebaseDatabase.instance.reference().child('Inventory');

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
    final booksProvider = Provider.of<BooksProvider>(context);
    books = booksProvider.books;
    newIDBook = books[books.length - 1].getID() + 1;

    final categoryProvider = Provider.of<CategoryProvider>(context);
    categories = categoryProvider.categories;

    final authorProvider = Provider.of<AuthorProvider>(context);
    authors = authorProvider.authors;

    final publisherProvider = Provider.of<PublisherProvider>(context);
    publishers = publisherProvider.publishers;


    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 30),
            Center(
                child: Text(
                  'Add New Book',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
            ),
            SizedBox(height: 8),
            Container(
              height: MediaQuery.of(context).size.height - 170,
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
                              hintText: newIDBook.toString()
                          ),
                        ),
                      ),

                      Text("Title"),
                      Container(
                        padding: EdgeInsets.only( top: 4.0, bottom: 4.0),
                        child: TextFormField(
                          controller: _titleController,
                          validator: (value) {
                            if(value!.isEmpty) {
                              return "Please enter book's title";
                            } else return null;
                          },
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
                                value: selectedNameCategory,
                                onChanged: (String? newValue) {
                                  setState(
                                          () {
                                        selectedNameCategory = newValue.toString();
                                        selectedIDCategory = getIDCategory(selectedNameCategory);
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
                          validator: (value) {
                            if(value!.isEmpty) {
                              return "Please enter book's genre";
                            } else return null;
                          },
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
                                value: selectedNameAuthor,
                                onChanged: (String? newValue) {
                                  setState(
                                          () {
                                        selectedNameAuthor = newValue.toString();
                                        selectedIDAuthor = getIDAuthor(selectedNameAuthor);
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
                                        selectedIDPublisher = getIDPublisher(selectedNamePublisher);
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
                          validator: (value) {
                            if(value!.isEmpty) {
                              return "Please enter book's publishing year";
                            } else return null;
                          },
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
                              hintText: 'Publishing Year'),
                        ),
                      ),

                      Text("Price"),
                      Container(
                        padding: EdgeInsets.only( top: 4.0, bottom: 4.0),
                        child: TextFormField(
                          controller: _priceController,
                          validator: (value) {
                            if(value!.isEmpty) {
                              return "Please enter book's price";
                            } else return null;
                          },
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
                              hintText: 'Price'),
                        ),
                      ),

                      Text("Available"),
                      Container(
                        padding: EdgeInsets.only( top: 4.0, bottom: 4.0),
                        child: TextFormField(
                          controller: _availableController,
                          validator: (value) {
                            if(value!.isEmpty) {
                              return "Please enter book's available quantity";
                            } else return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              available = value;
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
                              hintText: 'Avaiable'),
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
                          validator: (value) {
                            if(value!.isEmpty) {
                              return "Please enter book's publishing year";
                            } else return null;
                          },
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
                            onPressed: () async {

                              if(formKey.currentState!.validate()) {
                                if(fileImageArray.length > 0) {
                                  EasyLoading.show(status: 'Adding this book...');
                                  int booksLength = books.length;
                                  firebase_storage.FirebaseStorage storage =
                                      firebase_storage.FirebaseStorage.instance;

                                  await Books
                                      .doc(newIDBook.toString())
                                      .set({'author_id': selectedIDAuthor, 'book_id': newIDBook, 'category_id': selectedIDCategory, 'genre': genre,
                                    'image_url': [], 'price': int.parse(price), 'publisher_id': selectedIDPublisher,
                                    'publishing_year': int.parse(publishing_year),'sold_count': 0, 'summary': summary, 'title': title});

                                  await refInventory.child(newIDBook.toString())
                                      .update({'book_id': newIDBook, 'quantity': int.parse(available)});

                                  String no_image1 = "https://firebasestorage.googleapis.com/v0/b/book-store-app-3d8a6.appspot.com/o/no_image.jpg?alt=media&token=c607c944-0b3c-425b-adb9-0c972623bf56";
                                  String no_image2 = "https://firebasestorage.googleapis.com/v0/b/book-store-app-3d8a6.appspot.com/o/no_image2.jpg?alt=media&token=f214bf93-91ac-4d69-b885-5cc73970b020";

                                  if(fileImageArray.length == 1) {
                                    firebase_storage.Reference ref = storage.ref().child(fileImageArray[0].path);
                                    firebase_storage.UploadTask uploadTask = ref.putFile(fileImageArray[0]);
                                    uploadTask.whenComplete(() async {
                                      String url = await ref.getDownloadURL();
                                      if(url != "") {
                                        await Books.doc(newIDBook.toString()).update({'image_url': FieldValue.arrayUnion([url])});
                                        await Books.doc(newIDBook.toString()).update({'image_url': FieldValue.arrayUnion([no_image1])});
                                        await Books.doc(newIDBook.toString()).update({'image_url': FieldValue.arrayUnion([no_image2])});
                                        List<String> image_url = [];
                                        image_url.add(url);
                                        image_url.add(no_image1);
                                        image_url.add(no_image2);

                                        Book book = new Book(newIDBook, selectedIDAuthor, selectedIDCategory, genre, image_url, double.parse(price),
                                            selectedIDPublisher, int.parse(publishing_year), 0, summary, title);
                                        booksProvider.addBook(book);

                                        is_AddSuccessfully(booksLength, booksProvider.books.length);
                                      }
                                    });
                                  }

                                  else if(fileImageArray.length == 2) {
                                    List<String> image_url = [];
                                    firebase_storage.Reference ref1 = storage.ref().child(fileImageArray[0].path);
                                    firebase_storage.UploadTask uploadTask1 = ref1.putFile(fileImageArray[0]);
                                    uploadTask1.whenComplete(() async {
                                      String url1 = await ref1.getDownloadURL();
                                      if(url1 != "") {
                                        await Books.doc(newIDBook.toString()).update({'image_url': FieldValue.arrayUnion([url1])});
                                        image_url.add(url1);
                                      }
                                    });

                                    firebase_storage.Reference ref2 = storage.ref().child(fileImageArray[1].path);
                                    firebase_storage.UploadTask uploadTask2 = ref2.putFile(fileImageArray[1]);
                                    uploadTask2.whenComplete(() async {
                                      String url2 = await ref2.getDownloadURL();
                                      if(url2 != "") {
                                        await Books.doc(newIDBook.toString()).update({'image_url': FieldValue.arrayUnion([url2])});
                                        await Books.doc(newIDBook.toString()).update({'image_url': FieldValue.arrayUnion([no_image1])});
                                        image_url.add(url2);
                                        image_url.add(no_image1);

                                        Book book = new Book(newIDBook, selectedIDAuthor, selectedIDCategory, genre, image_url, double.parse(price),
                                            selectedIDPublisher, int.parse(publishing_year), 0, summary, title);
                                        booksProvider.addBook(book);

                                        is_AddSuccessfully(booksLength, booksProvider.books.length);
                                      }
                                    });
                                  }

                                  else if(fileImageArray.length == 3) {
                                    List<String> image_url = [];
                                    firebase_storage.Reference ref1 = storage.ref().child(fileImageArray[0].path);
                                    firebase_storage.UploadTask uploadTask1 = ref1.putFile(fileImageArray[0]);
                                    uploadTask1.whenComplete(() async {
                                      String url1 = await ref1.getDownloadURL();
                                      if(url1 != "") {
                                        await Books.doc(newIDBook.toString()).update({'image_url': FieldValue.arrayUnion([url1])});
                                        image_url.add(url1);
                                      }
                                    });

                                    firebase_storage.Reference ref2 = storage.ref().child(fileImageArray[1].path);
                                    firebase_storage.UploadTask uploadTask2 = ref2.putFile(fileImageArray[1]);
                                    uploadTask2.whenComplete(() async {
                                      String url2 = await ref2.getDownloadURL();
                                      if(url2 != "") {
                                        await Books.doc(newIDBook.toString()).update({'image_url': FieldValue.arrayUnion([url2])});
                                        image_url.add(url2);
                                      }
                                    });

                                    firebase_storage.Reference ref3 = storage.ref().child(fileImageArray[2].path);
                                    firebase_storage.UploadTask uploadTask3 = ref3.putFile(fileImageArray[2]);
                                    uploadTask3.whenComplete(() async {
                                      String url3 = await ref3.getDownloadURL();
                                      if(url3 != "") {
                                        await Books.doc(newIDBook.toString()).update({'image_url': FieldValue.arrayUnion([url3])});
                                        image_url.add(url3);
                                        Book book = new Book(newIDBook, selectedIDAuthor, selectedIDCategory, genre, image_url, double.parse(price),
                                            selectedIDPublisher, int.parse(publishing_year), 0, summary, title);
                                        booksProvider.addBook(book);

                                        is_AddSuccessfully(booksLength, booksProvider.books.length);
                                      }
                                    });
                                  }

                                }
                                else {
                                  Fluttertoast.showToast(
                                      msg: 'Please select at least one image before adding this book',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM);
                                }

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
    );

  }

  int getIDCategory(String name) {
    for(int i = 0; i < categories.length; i++) {
      if(name == categories[i].getNAME()) return categories[i].getID();
    }
    return 0;
  }

  int getIDAuthor(String name) {
    for(int i = 0; i < authors.length; i++) {
      if(name == authors[i].getNAME()) return authors[i].getID();
    }
    return 0;
  }

  int getIDPublisher(String name) {
    for(int i = 0; i < publishers.length; i++) {
      if(name == publishers[i].getNAME()) return publishers[i].getID();
    }
    return 0;
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

  void is_AddSuccessfully(int length1, int length2) {
    if(length1 < length2) {
      _genreController.clear();
      _publishingYearController.clear();
      _priceController.clear();
      _availableController.clear();
      _titleController.clear();
      _summaryController.clear();
      genre = "";
      publishing_year = "";
      price = "";
      available = "";
      title = "";
      summary = "";
      setState(() {
        fileImageArray = [];
        images = [];
        newIDBook++;
      });
      EasyLoading.showSuccess('Added this book successfully');
      Future.delayed(const Duration(milliseconds: 1000), () {
        EasyLoading.dismiss();
      });

    }
    else {
      EasyLoading.showError('Some errors occurs');
      Future.delayed(const Duration(milliseconds: 1000), () {
        EasyLoading.dismiss();
      });
    }
  }
}




