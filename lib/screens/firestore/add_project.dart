import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasedemo/screens/firestore/firestore.dart';
import 'package:firebasedemo/services/firestore_service.dart';
import 'package:flutter/material.dart';

class AddProjectScreen extends StatefulWidget {
  QueryDocumentSnapshot<Object?>? project;
   AddProjectScreen({super.key,
    this.project});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  // global key for the form
  final _formKey = GlobalKey<FormState>();
  // controller for the name project field
  final _nameProjectController = TextEditingController();
  // controller for the description project field
  final _descriptionProjectController = TextEditingController();


  @override
  void initState() {
    super.initState();
    if(widget.project != null){
      _nameProjectController.text = widget.project!.get('name');
      _descriptionProjectController.text = widget.project!.get('description');
    }
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 2));
    _controller.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FireStoreScreen()),
        );
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project == null ? 'Add Project' : 'Update Project'),
      ),
      body:
      Container(
        margin: EdgeInsets.all(20),
        child:
      Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 20,),
            TextFormField(
              controller: _nameProjectController,
              decoration: InputDecoration(
                labelText: 'Name Project',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter name project';
                }
                return null;
              },
            ),
            SizedBox(height: 20,),
            TextFormField(
              controller: _descriptionProjectController,
              decoration: InputDecoration(
                labelText: 'Description Project',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter description project';
                }
                return null;
              },
            ),
            SizedBox(height: 60,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(200, 60),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _controller.forward();
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(content: Text('Processing Data')),
                  // );

                  String textDialog = 'Add Project Success';

                  if(widget.project != null){
                    FirestoreService().updateProject(widget.project!.id, _nameProjectController.text, _descriptionProjectController.text);
                    textDialog = 'Update Project Success';
                  }else{
                    FirestoreService().createProject(_nameProjectController.text, _descriptionProjectController.text);
                  }


                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: AnimatedBuilder(
                        animation: _controller,
                        builder: (BuildContext context, Widget? child) {
                          return LinearProgressIndicator(
                            value: _controller.value,
                          );
                        },
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_outline, color: Colors.green, size: 160,),
                          SizedBox(height: 20,),
                          Text(textDialog, style: TextStyle(fontSize: 20),),
                        ],
                      ),

                    ),
                  );

                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: widget.project == null ? [Icon(Icons.add_circle_outline), SizedBox(width: 20,), const Text('Add Project'),] : [Icon(Icons.update), SizedBox(width: 20,), const Text('Update Project'),],
            ),
            ),
        ],

        ),
      ),
      ),

    );
  }
}
