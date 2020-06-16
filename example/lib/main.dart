import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sharedpreferences/SharedPreferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final SharedPreferences preferences = SharedPreferences("testsuite");

  int _storedKeys = 0;

  @override
  void initState() {
    super.initState();
    initStoredKeys();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initStoredKeys() async {
    int storedKeys;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      storedKeys = preferences.getKeys().length;
    } on Exception {
      storedKeys = 0;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _storedKeys = storedKeys;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("$_storedKeys preferences stored"),
                ),

                RaisedButton(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Add Preference",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  color: Colors.lightBlue,
                  onPressed: () {
                    preferences.setBool("$_storedKeys", true);
                    initStoredKeys();
                  }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
