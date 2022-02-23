import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'DatabaseHelper.dart';
import 'SignUpScreen.dart';

class Pin extends StatefulWidget {
  @override
  _PinState createState() => _PinState();
}

class _PinState extends State<Pin> {
  TextEditingController pinController = TextEditingController();
  var args;
  var myPin;
  final _formKey = GlobalKey<FormState>();

  getPin() {
    var dbHelper = DatabaseHelper();
    var images = dbHelper.getUser();
    print("Pin images");
    print(images);
    images.then((value) {
      setState(() {
        print("then");
        myPin = value[0].pin;
        print(value[0].pin);
        print("then");
      });
    });

    return images;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPin();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      args = ModalRoute.of(context).settings.arguments;
    });
    return Scaffold(
        appBar: AppBar(title: Text("Pin")),
        body: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 60,
              ),
              Form(
                key: _formKey,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty ||
                            value.length < 4 ||
                            value.length > 4) {
                          return 'Pin must be of 4 characters';
                        }
                        return null;
                      },
                      controller: pinController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        hintText: 'Enter Pin',
                        labelText: 'Pin',
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.yellow, width: 2.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 2.0),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    )),
              ),
              RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    if (myPin != null) {
                      if (myPin != pinController.text) {
                        Fluttertoast.showToast(
                            msg: "Incorrect Pin",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            //  timeInSecForIos: 3,
                            // backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SignUpScreen(args, pinController.text)));
                      }
                    } else {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  SignUpScreen(args, pinController.text)));
                    }
                  }
                },
                child: Text("Save"),
              )
            ],
          ),
        ));
  }

  String validatePassword(String value) {
    if (!(value.length > 4) && value.isNotEmpty) {
      return "Pin should contain more than 4 characters";
    }
    return null;
  }
}
