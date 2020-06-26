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
                    final key = _storedKeys;
                    preferences.setInt("int$key", key);
                    preferences.setBool("bool$key", true);
                    preferences.setDouble("double$key", key.toDouble());
                    preferences.setString("string$key", "$key");
                    preferences.setStringList("stringlist$key", ["0$key", "1$key", "2$key", "3$key", "4$key"]);

                    initStoredKeys();

                    print("");
                    print("INT: Set value " + preferences.getInt("int$key").toString() + " for key $key");
                    print("BOOL: Set value " + preferences.getBool("bool$key").toString() + " for key $key");
                    print("DOUBLE: Set value " + preferences.getDouble("double$key").toString() + " for key $key");
                    print("STRING: Set value " + preferences.getString("string$key").toString() + " for key $key");
                    print("STRINGLIST: Set value " + preferences.getStringList("stringlist$key").toString() + " for key $key");
                    print("");
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
