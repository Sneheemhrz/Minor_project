import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:picture_password/FirstScreen.dart';
import 'package:picture_password/Home.dart';
import 'package:picture_password/LoginScreen.dart';
import 'package:picture_password/Pin.dart';
import 'package:picture_password/SignUpScreen.dart';
import 'package:picture_password/SplashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Color.fromRGBO(214, 174, 0, 1),
        statusBarIconBrightness: Brightness.light));

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Theme.of(context).primaryColor,
          primaryColor: Color.fromRGBO(214, 174, 0, 1),
          accentColor: Color.fromRGBO(40, 96, 144, 1),

          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => FirstScreen(),
          '/pin': (context) => Pin(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => SignUpScreen('',''),
          '/home': (context) => Home(),

        });
  }
}
