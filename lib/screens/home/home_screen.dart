import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebasedemo/screens/firestore/firestore.dart';
import 'package:firebasedemo/screens/messaging_in_app.dart';
import 'package:flutter/material.dart';

import '../../widgets/nabvar.dart';
import '../storage/storage_screen.dart';



class HomeScreen extends StatefulWidget {


  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  User? user;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBarCustom(),
      body: Center(
      child: Text('Home Screen'),


    ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                          'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png'),
                    ),
                    Text(
                      '${user!.displayName}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(
                    width: 8,
                  ),
                  Text('Profile'),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      appBar: AppBar(
                        centerTitle: true,
                        title: Text('Profile'),
                      ),
                    ),

                  ),
                );
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.file_present),
                  SizedBox(
                    width: 8,
                  ),
                  Text('Storage'),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StorageScreen()
                  ),
                );
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.data_object_rounded),
                  SizedBox(
                    width: 8,
                  ),
                  Text('Firestore'),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FireStoreScreen()
                  ),
                );
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.message),
                  SizedBox(
                    width: 8,
                  ),
                  Text('In-App Messaging'),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MessagingScreen()
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
