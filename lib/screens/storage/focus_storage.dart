import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebasedemo/screens/storage/add_file.dart';
import 'package:firebasedemo/screens/storage/edit_file.dart';
import 'package:firebasedemo/services/storage_service.dart';
import 'package:flutter/material.dart';

class StorageFocusScreen extends StatefulWidget {
  String targetPath;

  StorageFocusScreen({super.key, required this.targetPath});

  @override
  State<StorageFocusScreen> createState() => _StorageFocusScreenState();
}

class _StorageFocusScreenState extends State<StorageFocusScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isBannerVisible = true;

  List<Map<String, dynamic>> iconByExtension = [
  {
  'extension' : 'jpg',
  'icon' : Icon(Icons.image),
  },
    {
      'extension' : 'png',
      'icon' : Icon(Icons.image),
    },
    {
      'extension' : 'txt',
      'icon' : Icon(Icons.text_fields),
    },
    {
      'extension' : 'pdf',
      'icon' : Icon(Icons.picture_as_pdf),
    }

];


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
        key: _scaffoldKey,


        appBar: AppBar(

          title: Text('${widget.targetPath}'),

        ),
      body:


      FutureBuilder(
        future: StorageService().getFiles(widget.targetPath),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('none');
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
              print(snapshot.data);
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
                      crossAxisCount: 2,

                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemBuilder: (context, index) {

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
            case ConnectionState.done:
              print('done');
              print(snapshot.data);
              if (snapshot.hasError) {
                return Text(
                  '${snapshot.error}',
                  style: TextStyle(color: Colors.red),
                );
              } else {
                if (snapshot.hasData) {
                  print('-' * 50);

                  return GridView.builder(
                    itemCount: snapshot.data!.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 2,
                      crossAxisCount: 2,

                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemBuilder: (context, index) {
                      Widget content = GestureDetector(
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
                      print(snapshot.data![index].name);
                      if(snapshot.data![index].name.split('.').last == 'png' || snapshot.data![index].name.split('.').last == 'jpg'){
                        String imgUrl = "";
                        Reference ref = snapshot.data![index];
                        
                        print(imgUrl);
                        content =
                            GestureDetector(
                              onLongPress: (){
                                print('longPress');
                                showDialog(
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                      Text('Edit or Delete'),
                                      IconButton(onPressed: (){
                                        Navigator.pop(context);
                                      }, icon: Icon(Icons.close, color: Colors.redAccent))
                                    ],),
                                    actionsAlignment: MainAxisAlignment.spaceEvenly,
                                    content:
                                    Container(
                                      height: MediaQuery.of(context).size.height *0.25,
                                      child:
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                      ElevatedButton(
                                        onPressed: (){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => EditFile(targetPath: widget.targetPath, fileName: snapshot.data![index].name))
                                          );
                                        },
                                        child: Row(children: [Icon(Icons.edit, color: Colors.white,),SizedBox(width: 20,), Text('Edit')],),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blueAccent,
                                          fixedSize: Size(150, 60)
                                        )
                                      ),
                                      SizedBox(
                                        width: 50,
                                      ),
                                      ElevatedButton(onPressed: ()async{
                                        await ref.delete();
                                        ScaffoldMessenger.of(context).showMaterialBanner(
                                           MaterialBanner(
                                             animation: _controller,

                                            elevation: 2,
                                            margin: EdgeInsets.all(10),
                                            padding: EdgeInsets.all(5),
                                            content: Text('Hello, I am a Material Banner'),
                                            leading: Icon(Icons.agriculture_outlined),
                                            backgroundColor: Colors.red,
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: (){
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                                                },
                                                child: Text('DISMISS'),
                                              ),
                                            ],

                                          ),


                                        );

                                      }, child: Row(children: [Icon(Icons.delete, color: Colors.white,),SizedBox(width: 20,), Text('Delete')],),
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.redAccent,
                                              fixedSize: Size(150, 60)

                                          ),

                                      )
                                    ],),
                                  ),
                                ),
                                );

                              },
                        child:
                            Container(
                          margin: EdgeInsets.all(10),
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              border: Border.all()

                            ),
                            child: FutureBuilder(
                            future: ref.getDownloadURL(),
                              builder: (context, snapshot) {
                                  if(snapshot.hasData){
                                    return Image.network('${snapshot.data}', fit: BoxFit.fitHeight,);
                                  }else{
                                    return Center(child:CircularProgressIndicator());
                                  }
                              },
                        ),
                            ),
                        );
                      }else if (snapshot.data![index].name.split('.').last == 'txt'){
                        return Container(
                          child: Center(child:Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.text_snippet, size: 50, color: Colors.blue,),
                              Text(snapshot.data![index].name),
                            ],
                          ),)
                        );

                      }

                      return content;
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
        }

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddFile(targetPath: widget.targetPath)),
          );
        },
        child: Icon(Icons.upload_file_rounded, color: Colors.white, size: 40,),
      )
    );
  }
}
