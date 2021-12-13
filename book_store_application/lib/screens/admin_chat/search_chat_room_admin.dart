import 'package:book_store_application/MVP/Model/User.dart';
import 'package:book_store_application/firebase/DatabaseManager.dart';
import 'package:book_store_application/firebase/providers/user_provider.dart';
import 'package:book_store_application/screens/admin_chat/chat_admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchChatRoomAdmin extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<SearchChatRoomAdmin> {

  DatabaseManager database = new DatabaseManager();
  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot? searchResultSnapshot;
  final FirebaseAuth auth = FirebaseAuth.instance;

  bool isLoading = false;
  bool haveUserSearched = false;

  initiateSearch() async {
    if(searchEditingController.text.isNotEmpty){
      setState(() {
        isLoading = true;
      });
      await database.searchByName(searchEditingController.text).then((snapshot){
        searchResultSnapshot = snapshot;
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  Widget userList(String admin_id){
    return haveUserSearched ? Container(
        height: MediaQuery.of(context).size.height - 80,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: searchResultSnapshot!.docs.length,
          itemBuilder: (context, index){
            return userTile(
              searchResultSnapshot!.docs[index]["name"],
              searchResultSnapshot!.docs[index]["id"],
              admin_id,
                searchResultSnapshot!.docs[index]["photo"]
            );
          },
        )) : Container();
  }




  Widget userTile(String name, String user_id, String admin_id, String photo){
    User_Model user = new User_Model('', name, 1, '', '', '', '', photo);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16
                ),
              ),
              // Text(
              //   userEmail,
              //   style: TextStyle(
              //       color: Colors.black,
              //       fontSize: 16
              //   ),
              // )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () async {
              String chatRoomId = user_id;
              database.seen(chatRoomId);
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ChatAdmin(
                    chatRoomId: chatRoomId,
                    admin_id: admin_id,
                    user: user,
                  )
              ));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(24)
              ),
              child: Text("Message",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),),
            ),
          )
        ],
      ),
    );
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user_model = Provider.of<UserProvider>(context);
    String admin_id = user_model.user.getID();
    return Scaffold(
      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator(),),
      ) : SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: Color(0x54FFFFFF),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchEditingController,
                      style: TextStyle(color: Colors.black,fontSize: 16),
                      decoration: InputDecoration(
                          hintText: "Search name ...",
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          border: InputBorder.none
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      initiateSearch();
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  const Color(0x36FFFFFF),
                                  const Color(0x0FFFFFFF)
                                ],
                                begin: FractionalOffset.topLeft,
                                end: FractionalOffset.bottomRight
                            ),
                            borderRadius: BorderRadius.circular(40)
                        ),
                        padding: EdgeInsets.all(12),
                        child: Image.asset("assets/images/search_white.png", height: 25, width: 25,color: Colors.blue,)),
                  )
                ],
              ),
            ),
            userList(admin_id)
          ],
        ),
      ),
    );
  }
}

