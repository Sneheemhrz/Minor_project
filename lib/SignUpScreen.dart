import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:picture_password/model.dart';
import 'package:rect_getter/rect_getter.dart';

import 'DatabaseHelper.dart';
import 'EncodeImage.dart';

class SignUpScreen extends StatefulWidget {
  var args;
  String text;
  SignUpScreen(this.args, this.text);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  Image image;
  String imagename = "";

  var globalKey = RectGetter.createGlobalKey();
  Offset _tapPosition;
  var dx;
  var dy;
  var pointsX = [];
  var pointsY = [];
  var xs;
  var xy;
 Future pickImageFromGallery() async {
   ImagePicker.pickImage(source: ImageSource.gallery).then((imgFile) {
     setState(() {
       imagename = Utility.base64String(imgFile.readAsBytesSync());
       print(imagename);

     });
   });
 }

  void _handleTapDown(TapDownDetails details) {
    final RenderBox referenceBox = context.findRenderObject();
    setState(() {
      _tapPosition = referenceBox.globalToLocal(details.globalPosition);
      dx = double.parse(_tapPosition.dx.toStringAsFixed(2));
      dy = double.parse(_tapPosition.dy.toStringAsFixed(2));
      print(_tapPosition);
      pointsX.add(dx);
      pointsY.add(dy);
      xs=json.encode(pointsX);
      xy=json.encode(pointsY);
      print(dx);
      print(dy);
      print(pointsX);
      print(pointsY);
      print(xs);
      print(xy);
    });
  }

  var args;

  @override
  Widget build(BuildContext context) {
    setState(() {
      args = ModalRoute.of(context).settings.arguments;
    });
    print("Args");
    print(widget.args);
    return Scaffold(
      appBar: AppBar(
        title: Text("SignUp"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
             pickImageFromGallery();
            },
          ),
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () async {
//                if (args == 0) {
                if (imagename != null) {
                  if (dx != null && dy != null) {
                    var db = new DatabaseHelper();
                    var datas = Models(imagename, xs, xy,widget.text);
                    if (widget.args == 0) {

                      await db.saveUser(datas);

                      Fluttertoast.showToast(
                          msg:
                          "Success!, Please login to continue",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          //  timeInSecForIos: 3,
                          // backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      Navigator.pushReplacementNamed(context, '/');
                    } else {
                      Fluttertoast.showToast(
                          msg:
                          "Success!, Please login to continue",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          //  timeInSecForIos: 3,
                          // backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      Navigator.pushReplacementNamed(context, '/');
                      await db.update(datas);
                    }
                  } else {
                    Fluttertoast.showToast(
                        msg: "Choose your point ",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        //    timeInSecForIos: 3,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                } else {
                  Fluttertoast.showToast(
                      msg: "Choose your picture ",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      //    timeInSecForIos: 3,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  //     }
//                }
//                else {
//                  if (imagename != null) {
//                    if (dx != null && dy != null) {
//                      var db = new DatabaseHelper();
//                      var dat = Models(imagename, dx, dy);
//                      await db.update(dat);
//                    } else {
//                      Fluttertoast.showToast(
//                          msg: "Choose your point ",
//                          toastLength: Toast.LENGTH_SHORT,
//                          gravity: ToastGravity.BOTTOM,
//                          //    timeInSecForIos: 3,
//                          backgroundColor: Colors.red,
//                          textColor: Colors.white,
//                          fontSize: 16.0);
//                    }
//                  } else {
//                    Fluttertoast.showToast(
//                        msg: "Choose your picture ",
//                        toastLength: Toast.LENGTH_SHORT,
//                        gravity: ToastGravity.BOTTOM,
//                        //    timeInSecForIos: 3,
//                        backgroundColor: Colors.red,
//                        textColor: Colors.white,
//                        fontSize: 16.0);
//                  }
                }
              })
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
//            RaisedButton(
//              child: Text("Upload Image"),
//              onPressed: () {
//                pickImageFromGallery();
//              },
//            ),
            RectGetter(
              key: globalKey,
              child: new Expanded(
                child: new InkWell(
                  onTap: () {
//                    var rect = RectGetter.getRectFromKey(globalKey);
//                    print(rect);
                  },
                  onTapDown: _handleTapDown,
                  child: Center(
                    child: Container(
                      child: Utility.imageFromBase64String(imagename),
                      //  backgroundColor: const Color(0xFF20283e),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
