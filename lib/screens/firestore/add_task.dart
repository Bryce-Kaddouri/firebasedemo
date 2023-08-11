import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasedemo/screens/firestore/focus_firestore.dart';
import 'package:flutter/material.dart';

import '../../services/firestore_service.dart';

class AddTaskScreen extends StatefulWidget {
  QueryDocumentSnapshot<Object?> project;
  QueryDocumentSnapshot<Object?>?  task;

  AddTaskScreen({super.key, required this.project, this.task});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  // global key for the form
  final _formKey = GlobalKey<FormState>();
  // controller for the name project field
  final _nameTaskController = TextEditingController();
  // controller for the description project field
  final _descriptionTaskController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 2));
    _controller.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FocusFireStoreScreen(project: widget.project,),),
        );
      }
    });
    if(widget.task != null){
      _nameTaskController.text = widget.task!.get('name');
      _descriptionTaskController.text = widget.task!.get('description');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Update Task'),
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
              controller: _nameTaskController,
              decoration: InputDecoration(
                labelText: 'Name Task',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter name task';
                }else if (value.length < 5){
                  return 'Name task must be at least 5 characters';
                }else if (value == widget.task?.get('name')){
                  return 'Name task must be different from the previous one';
                }
                return null;
              },
            ),
            SizedBox(height: 20,),
            TextFormField(
              controller: _descriptionTaskController,
              decoration: InputDecoration(
                labelText: 'Description Task',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter description task';
                }else if (value.length < 10){
                  return 'Description task must be at least 10 characters';
                }else if (value == widget.task?.get('description')){
                  return 'Description task must be different from the previous one';
                }
                return null;
              },
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  String textDialog = 'Add Task Success';
                  if(widget.task == null){
                    // add project
                    FirestoreService().createTask(widget.project.id, _nameTaskController.text, _descriptionTaskController.text);
                  }else{
                    textDialog = 'Update Task Success';
                    // update project
                    FirestoreService().updateTask(widget.project.id, widget.task!.id,null, _nameTaskController.text, _descriptionTaskController.text);
                  }
                  _controller.forward();
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
              child: Text(widget.task == null ? 'Add Task' : 'Update Task'),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
