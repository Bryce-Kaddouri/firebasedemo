import 'package:firebasedemo/screens/authentification/signin/signin.dart';
import 'package:firebasedemo/services/auth_service.dart';
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
            AuthService.signOut();
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => SigninScreen()));
          },
        ),
      ],
    );
  }
}
