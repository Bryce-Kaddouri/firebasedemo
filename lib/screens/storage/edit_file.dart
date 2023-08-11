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

class EditFile extends StatefulWidget {
  String targetPath;
  String fileName;

  EditFile({super.key, required this.targetPath, required this.fileName});

  @override
  State<EditFile> createState() => _EditFileState();
}

class _EditFileState extends State<EditFile> with SingleTickerProviderStateMixin{
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
  String fileName = "";
  bool isComplete = false;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 2));
    _controller.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        setState(() {
          isComplete = true;
        });


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
        title: Text('Edit File'),
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
              'Edit File',
            ),

            SizedBox(height: 20),




            _image == null ? FutureBuilder(
                future: StorageService().getDownloadUrl(widget.targetPath, widget.fileName),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {

                    Reference reference = FirebaseStorage.instance.refFromURL(snapshot.data.toString());
                    print(reference.fullPath);
                    print(reference.name);
                    fileName = reference.name;
                    if(kIsWeb){
                      return Image.network(snapshot.data.toString());
                    } else {
                      return Image.file(File(snapshot.data.toString()));
                    }
                  } else {
                    return CircularProgressIndicator();
                  }
                }
            ) : kIsWeb ? Image.network(_image!.path) : Image.file(File(_image!.path)),

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


                  Reference reference = FirebaseStorage.instance
                      .ref()
                      .child("users")
                      .child(user.uid)
                      .child(widget.targetPath)
                      .child('$fileName');

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
                            AnimatedBuilder(
                              animation: _controller,
                              builder: (BuildContext context, Widget? child) {
                                if(isComplete){
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.check_circle, color: Colors.green, size: 120,),
                                      SizedBox(height: 20),
                                      Text(
                                        "Upload Complete",
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Text(
                                    "Uploading ${(_controller.value * 100).toStringAsFixed(0)}%",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  );
                                }
                              },
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  );



                  uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {


                    switch (taskSnapshot.state) {
                      case TaskState.running:
                        final progress =
                            100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
                        print("Upload is $progress% complete.");


                        _controller.value = progress /100;


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

                          isComplete = true;

                        print("Upload is complete");
                        print("bloqué pendant 10 sec");
                        await Future.delayed(Duration(seconds: 10)).then((value) => print('10 secondes écoulées'));
                        // bloquer pendant 2 secondes
                        for (int i = 2; i >= 0; i--) {
                          print('$i secondes restantes...');
                          await Future.delayed(Duration(seconds: 1));
                        }
                        print('Action débloquée!');



                        // Handle successful uploads on complete
                      // ...
                        break;
                    }
                  }, onDone: () async {
                    print('done');
                    await Future.delayed(Duration(seconds: 2), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StorageFocusScreen(targetPath: widget.targetPath)),
                      );
                    });
                  }
                  );


                }
                /*setState(() {
                  _isLoading = false;
                });*/
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
