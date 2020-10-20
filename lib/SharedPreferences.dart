import 'MethodChannel.dart';



/// Wraps NSUserDefaults (on iOS) and SharedPreferences (on Android), providing
/// a persistent store for simple data.
///
/// Data is persisted to disk asynchronously.
class SharedPreferences {
  


  SharedPreferences([ this.filename = "flutterDefaultPreferences" ]) {
    reload();
  }
  
  /// Fetches value from the host platform
  /// Needs to be called before getting preferences. 
  Future<void> init() async {
    await reload();
  }
  
  static SharedPreferences standard = SharedPreferences();

  

  static MethodChannelSharedPreferencesStore get _store => MethodChannelSharedPreferencesStore.instance;
  
  

  final String filename;



  /// The cache that holds all preferences.
  ///
  /// It is instantiated to the current state of the SharedPreferences or
  /// NSUserDefaults object and then kept in sync via setter methods in this
  /// class.
  ///
  /// It is NOT guaranteed that this cache and the device prefs will remain
  /// in sync since the setter method might fail for any reason.
  final _preferenceCache = <String, Object> {};



  /// Returns all keys in the persistent storage.
  Set<String> getKeys() => Set<String>.from(_preferenceCache.keys);



  /// Reads a value of any type from persistent storage.
  dynamic get(String key) => _preferenceCache[key];

  /// Reads a value from persistent storage, throwing an exception if it's not a
  /// bool.
  bool getBool(String key) => _preferenceCache[key];

  /// Reads a value from persistent storage, throwing an exception if it's not
  /// an int.
  int getInt(String key) => _preferenceCache[key];

  /// Reads a value from persistent storage, throwing an exception if it's not a
  /// double.
  double getDouble(String key) => _preferenceCache[key];

  /// Reads a value from persistent storage, throwing an exception if it's not a
  /// String.
  String getString(String key) => _preferenceCache[key];

  /// Reads a set of string values from persistent storage, throwing an
  /// exception if it's not a string set.
  // Make a copy of the list so that later mutations won't propagate
  List<String> getStringList(String key) => (_preferenceCache[key] is List<String>) ? (_preferenceCache[key] as List<String>).toList() : null;



  /// Saves a boolean [value] to persistent storage in the background.
  ///
  /// If [value] is null, this is equivalent to calling [remove()] on the [key].
  Future<bool> setBool(String key, bool value) => _setValue('Bool', key, value);

  /// Saves an integer [value] to persistent storage in the background.
  ///
  /// If [value] is null, this is equivalent to calling [remove()] on the [key].
  Future<bool> setInt(String key, int value) => _setValue('Int', key, value);

  /// Saves a double [value] to persistent storage in the background.
  ///
  /// Android doesn't support storing doubles, so it will be stored as a float.
  ///
  /// If [value] is null, this is equivalent to calling [remove()] on the [key].
  Future<bool> setDouble(String key, double value) => _setValue('Double', key, value);

  /// Saves a string [value] to persistent storage in the background.
  ///
  /// If [value] is null, this is equivalent to calling [remove()] on the [key].
  Future<bool> setString(String key, String value) => _setValue('String', key, value);

  /// Saves a list of strings [value] to persistent storage in the background.
  ///
  /// If [value] is null, this is equivalent to calling [remove()] on the [key].
  Future<bool> setStringList(String key, List<String> value) => _setValue('StringList', key, value);



  /// Returns true if persistent storage the contains the given [key].
  bool containsKey(String key) => _preferenceCache.containsKey(key);



  /// Removes an entry from persistent storage.
  Future<bool> remove(String key) {
    _preferenceCache.remove(key);
    return _store.remove(key, filename);
  }



  Future<bool> _setValue(String valueType, String key, Object value) {

    // If value is a string list make a copy of it so that later mutations won't propagate.
    _preferenceCache[key] = (value is List<String>) ? value.toList() : value;

    return _store.setValue(valueType, key, value, filename);
  }



  /// Completes with true once the user preferences for the app has been cleared.
  Future<bool> clear() {
    _preferenceCache.clear();
    return _store.clear(filename);
  }



  /// Fetches the latest values from the host platform.
  ///
  /// Use this method to observe modifications that were made in native code
  /// (without using the plugin) while the app is running.
  Future<void> reload() async {
    final Map<String, Object> preferences = await _store.getAll(filename);
    _preferenceCache.clear();
    _preferenceCache.addAll(preferences);
  }
}
