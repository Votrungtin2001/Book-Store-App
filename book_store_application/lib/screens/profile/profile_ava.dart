import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';

import 'package:book_store_application/firebase/providers/user_provider.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({Key? key,}) : super(key: key);

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
            child: Image.network(photo, fit: BoxFit.cover),
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
                onPressed: () {},
                child: const Icon(Icons.camera_alt,color: Colors.black,),
              ),
            ),
          )
        ],
      ),
    );
  }
}