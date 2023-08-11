import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasedemo/screens/home/home_screen.dart';
import 'package:firebasedemo/screens/storage/storage_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

// import image picker
import 'package:image_picker/image_picker.dart';

import '../../services/storage_service.dart';

class AddFolder extends StatefulWidget {
  const AddFolder({super.key});

  @override
  State<AddFolder> createState() => _AddFolderState();
}

class _AddFolderState extends State<AddFolder> with SingleTickerProviderStateMixin{

  late AnimationController _controller;

  // global key for the form
  final _formKey = GlobalKey<FormState>();
  // controller for the path field
  final _pathController = TextEditingController();
  // regex to validate the path (example: /path/to
  bool _isLoading = false;
  // controller for the material banner
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  File? _image;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 2));
    _controller.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StorageScreen()),
        );
      }
    });


  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Folder'),
      ),
      body:
      SingleChildScrollView(child:Container(
        padding: EdgeInsets.all(20),
        child:
        Form(
          key: _formKey,
          child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'Add File',
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _pathController,
              decoration: InputDecoration(
                labelText: 'Path',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a path';
                }

                return null;
              },
            ),
            SizedBox(height: 20),

            Container(
              height: _image == null ? 0 : MediaQuery.of(context).size.height * 0.5,
              child: _image == null
                  ? Text('No image selected.')
                  : kIsWeb ? Image.network(_image!.path) : Image.file(_image!),
            ),

            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                _controller.forward();
                setState(() {
                  _isLoading = true;
                });

                if (_formKey.currentState!.validate()) {
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user == null) return;
/*
                  String? response = await StorageService().uploadFile(file: _image!, path: 'test', name: 'test.jpg', contentType: 'image/jpeg');
*/
                await StorageService().createFolder( name: '${_pathController.text}');
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => AlertDialog(
                      title: AnimatedBuilder(
                        animation: _controller,
                        builder: (BuildContext context, Widget? child) {
                          return LinearProgressIndicator(
                            value: _controller.value,
                          );
                        },
                      ),
                      content: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle, color: Colors.green, size: 120),
                            SizedBox(height: 20),
                            Text('Please wait...'),
                          ],
                        ),
                      ),


                    ),
                  );
/*
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StorageScreen()));
*/


                }

              },
              child: _isLoading
                  ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload_file),
                  SizedBox(width: 10),
                  Text('Upload File'),
                ],
              ),
            ),
          ],
        ),


        ),
      ),
      ),
    );
  }
}
