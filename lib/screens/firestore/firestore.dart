import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasedemo/screens/home/home_screen.dart';
import 'package:firebasedemo/services/firestore_service.dart';
import 'package:flutter/material.dart';

import 'add_project.dart';
import 'focus_firestore.dart';

class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({super.key});

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(


      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
        title: Text('FireStore'),
      ),
      body: StreamBuilder(
        stream: FirestoreService().getProjects(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              return Card(

                color: Colors.grey[400],
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FocusFireStoreScreen(project: document)),
                    );
                  },
                  leading: Icon(Icons.folder),
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
                          MaterialPageRoute(builder: (context) => AddProjectScreen(project: document)),
                        );
                      } else if (value == 'delete') {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Delete Project'),
                            content: Text('Are you sure you want to delete this project?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  FirestoreService().deleteProject(document.id);
                                  Navigator.pop(context);
                                },
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                  title: Text(document['name']),
                  subtitle: Text('created at ${DateTime.fromMillisecondsSinceEpoch(document['createdAt'].seconds * 1000)}'),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProjectScreen()),
          );
        },
        child: Icon(Icons.add),
      )
    );
  }
}
