import 'package:flutter/material.dart';

import 'DatabaseHelper.dart';
import 'model.dart';

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  int lenghts = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getValues();
  }

  Future<List<Models>> getValues() async {
    print("First");
    var dbHelper = DatabaseHelper();
    var images = dbHelper.getUser();
    print("images first");

    images.then((value) {
      setState(() {
        lenghts = value.length;
        print("then");
        print(lenghts);
        print("then");
      });
    });
    print("images first");
//    print(images.length);
    return images;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.dstATop),
              image: AssetImage("assets/lock.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Theme.of(context).primaryColor)),
                  onPressed: () {
                    Navigator.pushNamed(context, '/login', arguments: lenghts);
                  },
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    child: Text("Login".toUpperCase(),
                        style: TextStyle(fontSize: 14)),
                  ),
                ),

                SizedBox(height: 20),
                RaisedButton(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Theme.of(context).accentColor)),
                  onPressed: () {
                    Navigator.pushNamed(context, '/pin',
                        arguments: lenghts);
                  },
                  color: Theme.of(context).accentColor,
                  textColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    child: Text("Register".toUpperCase(),
                        style: TextStyle(fontSize: 14)),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
