import 'dart:async';

import 'package:flutter/material.dart';

import 'DatabaseHelper.dart';
import 'model.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var dbHelper = DatabaseHelper();
  var images;

  getValues() {
//    var dbHelper = DatabaseHelper();
    images = dbHelper.getUser();
    print("login Images");
    print(images);

    return images;
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      getValues();
      print("Imagessssss");
      print(images);
      images != null
          ? Navigator.pushReplacementNamed(context, '/login')
          : Navigator.pushReplacementNamed(context, '/register');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Center(
          child: Image.asset(
        'assets/logo.png',
        width: 300,
        height: 300,
      )),
    );
  }
}
