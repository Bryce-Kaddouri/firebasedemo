import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasedemo/screens/firestore/add_task.dart';
import 'package:firebasedemo/services/firestore_service.dart';
import 'package:flutter/material.dart';

class FocusFireStoreScreen extends StatefulWidget {
  QueryDocumentSnapshot<Object?> project;

  FocusFireStoreScreen({super.key, required this.project});

  @override
  State<FocusFireStoreScreen> createState() => _FocusFireStoreScreenState();
}

class _FocusFireStoreScreenState extends State<FocusFireStoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.project.get('name')}'),
      ),
      body: Column(
        children: [
          Container(height: 20, child: Text('is not Done :'),),
          Expanded(child: StreamBuilder(
            stream: FirestoreService().getTasksByStatus(widget.project.id, false),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              return ListView(
                children: snapshot.data!.docs.map((document) {
                  return Card(
                    color: Colors.grey[400],
                    child: ListTile(
                      leading: Checkbox(
                        value: document.get('isDone'),
                        onChanged: (value) {
                          // value = false if checked
                          FirestoreService().updateTask(widget.project.id, document.id, value, null, null);
                        },
                      ),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Text('Edit'),
                            value: 'edit',
                          ),
                          PopupMenuItem(
                            child: Text('Delete'),
                            value: 'delete',
                          ),
                        ],
                        onSelected: (value) {
                          if (value == 'edit') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => FocusFireStoreScreen(project: document)),
                            );
                          } else if (value == 'delete') {
                            FirestoreService().deleteTask(widget.project.id, document.id);
                          }
                        },
                      ),
                      title: Text(document.get('name')),
                      subtitle: Text(document.get('description')),
                    ),
                  );
                }).toList(),
              );
            },
          )

          ),
          Container(height: 20, child: Text('is Done :'),),

          Expanded(child: StreamBuilder(
            stream: FirestoreService().getTasksByStatus(widget.project.id, true),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              return ListView(
                children: snapshot.data!.docs.map((document) {
                  return Card(
                    color: Colors.grey[400],
                    child: ListTile(
                      leading: Checkbox(
                        value: document.get('isDone'),
                        onChanged: (value) {
                          // value = false if checked
                          FirestoreService().updateTask(widget.project.id, document.id, value, null, null);
                        },
                      ),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Text('Edit'),
                            value: 'edit',
                          ),
                          PopupMenuItem(
                            child: Text('Delete'),
                            value: 'delete',
                          ),
                        ],
                        onSelected: (value) {
                          if (value == 'edit') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AddTaskScreen(project: document)),
                            );
                          } else if (value == 'delete') {
                            FirestoreService().deleteTask(widget.project.id, document.id);
                          }
                        },
                      ),
                      title: Text(document.get('name')),
                      subtitle: Text(document.get('description')),
                    ),
                  );
                }).toList(),
              );
            },
          )

          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen(project: widget.project)),
          );
        },
        child: Icon(Icons.add),
      )
    );
  }
}
