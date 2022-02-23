import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:picture_password/files_model.dart';

// import 'package:flutter_html/flutter_html.dart';
import 'dart:io';
import 'dart:ui';
import 'DatabaseHelper.dart';
import 'EncodeImage.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Image image;
  String imagename = "";
  List<String> images = [];
  final picker = ImagePicker();
  File _image;
  var files;
  bool isLoading = false;

  Future pickImageFromGallery() async {
    var db;
    var datas;
    ImagePicker.pickImage(source: ImageSource.gallery).then((imgFile) async {
      db = new DatabaseHelper();
      datas = FilesModel(imagename);
      await db.saveFiles(datas);
      setState(() {
        imagename = Utility.base64String(imgFile.readAsBytesSync());
        print(imagename);
        images.add(imagename);
      });
    });
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(
              'Are you sure?',
              style: TextStyle(color: Colors.black),
            ),
            content: new Text('Do you want logout'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Future<List<FilesModel>> getValues() async {
    setState(() {
      isLoading = true;
    });
    var dbHelper = DatabaseHelper();

    files = dbHelper.getFiles();
    print("images");
    print(files);
    setState(() {
      isLoading = false;
    });
    return files;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getValues();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text("Home"),
              actions: [
                InkWell(
                    onTap: () => pickImageFromGallery(),
                    child: Icon(Icons.attach_file, color: Colors.white))
              ],
            ),
            body: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : FutureBuilder<dynamic>(
                    future: getValues(),
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? GridView.builder(
                              itemCount: snapshot.data.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                              itemBuilder: (BuildContext context, int i) {
                                return Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        height: 100,
                                        width: 100,
                                        child: Utility.imageFromBase64String(
                                            snapshot.data[i].image),
                                        //  backgroundColor: const Color(0xFF20283e),
                                      ),
                                      Positioned(
                                          right: 1,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                // snapshot.data.remove(snapshot.data[i].image);
                                                dltImages(snapshot.data[i]);
                                              });
                                            },
                                            child: Icon(Icons.cancel,
                                                color: Colors.red),
                                          ))
                                    ],
                                  ),
                                );
                              },
                            )
                          : Container(child: Text("No Items"));
                    })));
  }

  void dltImages(data) {
    var db = new DatabaseHelper();
    db.deleteFiles(data);
  }
}
