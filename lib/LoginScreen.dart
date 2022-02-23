import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:picture_password/DatabaseHelper.dart';
import 'package:picture_password/model.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'EncodeImage.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Offset _tapPosition;
  var dx;
  var dy;
  var x;
  var y;
  var dxP = [];
  var dyP = [];
  bool isFailed = false;
  var _globalKey = RectGetter.createGlobalKey();

  bool failed = false;

  void _handleTapDown(TapDownDetails details) {
    final RenderBox referenceBox = context.findRenderObject();
    setState(() {
      _tapPosition = referenceBox.globalToLocal(details.globalPosition);
      dx = double.parse(_tapPosition.dx.toStringAsFixed(2));
      dy = double.parse(_tapPosition.dy.toStringAsFixed(2));
      print(_tapPosition);
      dxP.add(dx);
      dyP.add(dy);
//      print("Handle");
//      print(dx);
//      print(dy);
    });
  }

  var args;

  void removeFailedIndex(int i) {
    setState(() {
      dxP.remove(dxP[i]);
      dyP.remove(dyP[i]);
      isFailed = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getValues();
  }

  Future<List<Models>> getValues() async {
    var dbHelper = DatabaseHelper();
    var images = dbHelper.getUser();
    print("images");
    print(images);

    return images;
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      args = ModalRoute.of(context).settings.arguments;
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        actions: [
          InkWell(
            onTap: ()=>{
              Navigator.pushReplacementNamed(context, '/pin')
            },
              child: Center(
            child: Text(
              "Forgot ?",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          )),
          SizedBox(
            width: 20,
          ),
          InkWell(
              onTap: () {
                setState(() {
                  dxP = [];
                  dyP = [];
                });
              },
              child: Center(
                  child: Text(
                "Try again",
                style: TextStyle(color: Colors.white, fontSize: 16),
              )))
        ],
      ),
      body: Container(
          child: args != 0
              ? FutureBuilder<dynamic>(
                  future: getValues(),
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? RectGetter(
                            key: _globalKey,
                            child: new InkWell(
                              onTap: () {
                                setState(() {
                                  print("X");
                                  print(snapshot.data[0].xc);
                                  x = json.decode(snapshot.data[0].xc);
                                  print(x);
                                  print("Y");
                                  print(snapshot.data[0].yc);
                                  y = json.decode(snapshot.data[0].yc);
                                  print(y);
                                });
                                for (int i = 0; i < x.length; i++) {
                                  if (dxP.length != x.length) {
                                    if (dxP[i] == x[i] ||
                                        dyP[i] == y[i] ||
                                        ((dxP[i] - 2.3) <= x[i] &&
                                            x[i] <= (dxP[i] + 2.3)) ||
                                        ((dyP[i] - 2.3) <= y[i] &&
                                            y[i] <= (dyP[i] + 2.3))) {
                                      // Fluttertoast.showToast(
                                      //     msg:
                                      //     "Success Please enter another point",
                                      //     toastLength: Toast.LENGTH_SHORT,
                                      //     gravity: ToastGravity.BOTTOM,
                                      //     //  timeInSecForIos: 3,
                                      //     // backgroundColor: Colors.red,
                                      //     textColor: Colors.white,
                                      //     fontSize: 16.0);
                                    } else {
                                      // Fluttertoast.showToast(
                                      //     msg:
                                      //     "Failed Please try again from ",
                                      //     toastLength: Toast.LENGTH_SHORT,
                                      //     gravity: ToastGravity.BOTTOM,
                                      //     //  timeInSecForIos: 3,
                                      //     // backgroundColor: Colors.red,
                                      //     textColor: Colors.white,
                                      //     fontSize: 16.0);
                                    }
                                  } else {
                                    if (dxP[dxP.length - 1] ==
                                            x[x.length - 1] ||
                                        dyP[dxP.length - 1] ==
                                            y[x.length - 1] ||
                                        ((dxP[dxP.length - 1] - 2.3) <=
                                                x[x.length - 1] &&
                                            x[x.length - 1] <=
                                                (dxP[dxP.length - 1] + 2.3)) ||
                                        ((dyP[dxP.length - 1] - 2.3) <=
                                                y[x.length - 1] &&
                                            y[x.length - 1] <=
                                                (dyP[dxP.length - 1] + 2.3))) {
                                      Navigator.pushReplacementNamed(
                                          context, '/home');
                                    } else {
                                      setState(() {
                                        failed = true;
                                      });
                                      showToast();
                                    }
                                  }
                                }
                              },
                              onTapDown: _handleTapDown,
                              child: Center(
                                child: Container(
                                  child: Utility.imageFromBase64String(
                                      snapshot.data[0].image),
                                  //  backgroundColor: const Color(0xFF20283e),
                                ),
                              ),
                            ),
                          )
                        : Container();
                  },
                )
              : Text("Please register")),
    );
  }

  void showToast() {
    if (failed) {
      Fluttertoast.showToast(
          msg: "Failed Please try again from beginning",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          //  timeInSecForIos: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
