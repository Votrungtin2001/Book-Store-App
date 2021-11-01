
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';
import 'package:path/path.dart';
import 'package:book_store_application/firebase/providers/user_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;



class ProfileAvatar extends StatefulWidget {
  const ProfileAvatar({Key? key}) : super(key: key);

  @override
  _ProfileAvatarState createState() => _ProfileAvatarState();
}
late File image;
late String filename;

class _ProfileAvatarState extends State<ProfileAvatar> {
  File? image;
  String? filename;

  Future _getImage() async{
    try{
   final image = await ImagePicker().pickImage(
        source: ImageSource.gallery
    );
    final imageTemporaty = File(image!.path);
    setState(() {
      this.image = imageTemporaty;
      this.filename = basename(image.path);
    }) ;
    }
    on PlatformException catch(e){
      print('Failed o pick image: $e');
    }

  }

  @override
  Widget build(BuildContext context) {
    final user_model = Provider.of<UserProvider>(context);
    String photo = user_model.user.getPhoto();
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            child: image!= null ? Image.file(image!, fit:BoxFit.cover)
                : Image.network(photo, fit: BoxFit.cover),
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 40,
              width: 40,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: Colors.white),
                  ),
                  primary: Colors.white,
                  backgroundColor: Color(0xFFF5F6F9),
                ),
                onPressed: () {
                  _getImage();
                },
                child: const Icon( Icons.camera_alt, color: Colors.black,),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget uploadArea(){
    return Column(
      children: <Widget>[

      ],
    );
  }
}



