import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyHeader extends StatelessWidget with PreferredSizeWidget {
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // leading: IconButton(
      //   onPressed: () => Navigator.pop(context),
      //   icon: Icon(
      //     Icons.arrow_back_ios_new_outlined,
      //     color: Theme.of(context).accentColor,
      //   ),
      // ),
      automaticallyImplyLeading: true,
      elevation: 2,
      toolbarHeight: 50,
      backgroundColor: const Color(0xFFF4E7F0),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.account_circle_outlined,
            color: Theme.of(context).accentColor,
          ),
        ),
        GestureDetector(
          onTap: signUserOut,
          child: Icon(
            Icons.logout_outlined,
            color: Theme.of(context).accentColor,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.settings_outlined,
            color: Theme.of(context).accentColor,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
