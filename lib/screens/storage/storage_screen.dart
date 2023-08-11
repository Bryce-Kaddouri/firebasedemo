import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasedemo/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_storage/firebase_ui_storage.dart';

import '../../widgets/nabvar.dart';
import 'add_folder.dart';
import 'focus_storage.dart';
class StorageScreen extends StatefulWidget {
  const StorageScreen({super.key});

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
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

          title: Text('Storage'),

        ),


      body: FutureBuilder(
        future: StorageService().getFolders(null),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('none');
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
              return Text('');
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text(
                  '${snapshot.error}',
                  style: TextStyle(color: Colors.red),
                );
              } else {
                if (snapshot.hasData) {
                  return GridView.builder(
                    itemCount: snapshot.data!.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 2,
                      crossAxisCount: 3,

                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemBuilder: (context, index) {
                      return
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => StorageFocusScreen(targetPath: snapshot.data![index].name)),
                            );
                          },
                          child: Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.folder, size: 50, color: Colors.blue,),
                                Text(snapshot.data![index].name),
                              ],
                            ),
                          ),
                        );

                    },
                  );
                } else {
                  return Container(
                    color: Colors.grey,
                    height: 200,
                    child: Center(
                      child: Text('No data'),
                    ),
                  );
                }
              }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddFolder()),
          );

          // Add your onPressed code here!
        },
        child: const Icon(Icons.create_new_folder_rounded, size: 40, color: Colors.white,),
        backgroundColor: Colors.blue,
      )
    );
  }
}
