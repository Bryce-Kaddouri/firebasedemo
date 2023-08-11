import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class NavBarCustom extends StatefulWidget implements PreferredSizeWidget {
  const NavBarCustom({super.key});

  @override
  State<NavBarCustom> createState() => _NavBarCustomState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(50);
}

class _NavBarCustomState extends State<NavBarCustom> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Home'),
      actions: [
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            FirebaseUIAuth.signOut(context: context);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => SignInScreen()));
          },
        ),
      ],
    );
  }
}
