import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasedemo/screens/storage/focus_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import image picker
import 'package:image_picker/image_picker.dart';

import '../../services/storage_service.dart';

class AddFile extends StatefulWidget {
  String targetPath;
   AddFile({super.key, required this.targetPath});

  @override
  State<AddFile> createState() => _AddFileState();
}

class _AddFileState extends State<AddFile> with SingleTickerProviderStateMixin{
  late AnimationController _controller;



  // global key for the form
  final _formKey = GlobalKey<FormState>();
  // controller for the path field
  final _pathController = TextEditingController();
  // regex to validate the path (example: /path/to
  bool _isLoading = false;

  XFile? _image;
  UploadTask? task = null;
  TaskSnapshot? tasksnap = null;
  String currentRate = "";


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 2));
    _controller.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StorageFocusScreen(targetPath: widget.targetPath)),
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
        title: Text('Add File'),
      ),
      body:
      SingleChildScrollView(
        child:Container(
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

            _image == null ? Container() : kIsWeb ? Image.network(_image!.path) : Image.file(File(_image!.path)),
            SizedBox(height: 20),


            ElevatedButton(
              onPressed: () async {
                final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (image == null) return;
                setState(() {
                  _image = image;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image),
                  SizedBox(width: 10),
                  Text('Pick Image'),
                ],
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });
                if(_image == null){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please pick an image'),
                    ),
                  ).closed.then((_) => setState(() => _isLoading = false));
                  return;
                }
                if (_formKey.currentState!.validate()) {
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user == null) return;
                  // Create the file metadata
                  final metadata = SettableMetadata(contentType: "image/jpeg");

                  String fileName = DateTime.now().millisecondsSinceEpoch.toString();
                  Reference reference = FirebaseStorage.instance
                      .ref()
                      .child("users")
                      .child(user.uid)
                      .child(widget.targetPath)
                      .child('$fileName.jpg');

                  print(reference);



                  UploadTask uploadTask =
                  /*reference.putFile(File(_image!.path));*/
                  reference.putData(
                    await _image!.readAsBytes()
                  );
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
                            Text(currentRate),
                          ],
                        ),
                      ),
                    ),
                  );



                  uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {

                    switch (taskSnapshot.state) {
                      case TaskState.running:
                        final progress =
                            100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
                        print("Upload is $progress% complete.");

                        _controller.value = progress /100;
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
                                  Text(currentRate),
                                ],
                              ),
                            ),
                          ),
                        );
                          currentRate = "Upload is $progress% complete.";

                        break;
                      case TaskState.paused:
                        print("Upload is paused.");
                        break;
                      case TaskState.canceled:
                        print("Upload was canceled");
                        break;
                      case TaskState.error:
                      // Handle unsuccessful uploads
                        break;
                      case TaskState.success:
                        print(taskSnapshot.ref);
                        Navigator.pop(context);

                        // Handle successful uploads on complete
                      // ...
                        break;
                    }
                  });


                }
                setState(() {
                  _isLoading = false;
                });
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
