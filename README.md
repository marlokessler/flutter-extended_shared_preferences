# Extended SharedPreferences
This is an extension of the [shared_preferences plugin](https://pub.dev/packages/shared_preferences "shared_preferences plugin") so that the function of multiple SharedPreference files is now supported in iOS and in Android. 

This plugin wraps NSUserDefaults (on iOS) and SharedPreferences (on Android), providing a persistent store for simple data. Data is persisted to disk asynchronously. Neither platform can guarantee that writes will be persisted to disk after returning and this plugin must not be used for storing critical data.

The deprecated `commit()` function is removed.

## Getting Started
Implement this plugin in your flutter project and use it with `SharedPreferences.standard` or `SharedPreferences()` to use the default preference store or use your own with `SharedPreferences("[Your preference file]")`.

You can read values by calling
```dart
  /// Read a bool value.
  var v = SharedPreferences().getBool([Your Key]);

  /// Read an int value.
  var v = SharedPreferences().getInt([Your Key]);

  /// Read a double value.
  var v = SharedPreferences().getDouble([Your Key]);

  /// Read a string value.
  var v = SharedPreferences().getString([Your Key]);

  /// Read a string list value.
  var v = SharedPreferences().getStringList([Your Key]);

  /// Read any value.
  var v = SharedPreferences().get([Your Key]);
```

Write values by calling
```dart
  /// Write a bool value.
  SharedPreferences().setBool([Your Key], [Bool Value]);

  /// Write an int value.
  SharedPreferences().setInt([Your Key], [Int Value]);

  /// Write a double value.
  SharedPreferences().setDouble([Your Key], [Double Value]);
    
  /// Write a string value.
  SharedPreferences().setString([Your Key], [String Value]);
    
  /// Write a string list.
  SharedPreferences().setStringList([Your Key], [String List]);
    
  /// Write any value.
  SharedPreferences().set([Your Key], [Value]);
```

You can check if a key exists by calling
```dart
  SharedPreferences().containsKey([Your Key]);
```

You get a key set of all keys of the current file by calling
```dart
  var v = SharedPreferences().getKeys();
```

You can reload the values from the disk manually by calling
```dart
  SharedPreferences().reload();
```

Values can be removed by calling
```dart
  SharedPreferences().remove([Your Key]);
```
or
```dart
  SharedPreferences().clear();
```
if you want to clear all values of the preference file.

## Usage
To use this plugin, add `extended_shared_preferences` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

### Example

``` dart
class AudioLevel extends StatefulWidget {
  @override
  _AudioLevelState createState() => _AudioLevelState();
}

class _AudioLevelState extends State<AudioLevel> {
  
  int audioLevel;
  
  final sharedPreferences = SharedPreferences("audioSettings");
  
  @override
  void initState() {
    audioLevel = sharedPreferences.getInt("audioLevel");
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Center(
      
      child: Column(
        children: <Widget>[
          Text("Current Level:"),
          Row(
            children: <Widget>[
              FlatButton(
                child: Icon(Icons.remove),
                onPressed: () => setState(() {
                  audioLevel--;
                  sharedPreferences.setInt("audioLevel", audioLevel);
                }),
              ),

              Text("$audioLevel"),

              FlatButton(
                child: Icon(Icons.add),
                onPressed: () => setState(() {
                  audioLevel++;
                  sharedPreferences.setInt("audioLevel", audioLevel);
                }),
              ),
            ],
          ),
        ],
      )
    );
  }
}
```