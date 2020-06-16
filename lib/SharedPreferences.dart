
import 'MethodChannel.dart';



class SharedPreferences {
  


  SharedPreferences([ this.filename = "flutterDefaultPreferences" ]) {
    reload();
  }
  
  static SharedPreferences standard = SharedPreferences();

  

  static MethodChannelSharedPreferencesStore get _store => MethodChannelSharedPreferencesStore.instance;
  
  

  final String filename;
  
  

  final _preferenceCache = <String, Object> {};



  Set<String> getKeys() => Set<String>.from(_preferenceCache.keys);



  dynamic get(String key) => _preferenceCache[key];

  bool getBool(String key) => _preferenceCache[key];

  int getInt(String key) => _preferenceCache[key];

  double getDouble(String key) => _preferenceCache[key];

  String getString(String key) => _preferenceCache[key];

  // If list is List<String> return it and make a copy of the list so that later mutations won't propagate.
  List<String> getStringList(String key) => (_preferenceCache[key] is List<String>) ? (_preferenceCache[key] as List<String>).toList() : null;
  


  Future<bool> setBool(String key, bool value) => _setValue('Bool', key, value);

  Future<bool> setInt(String key, int value) => _setValue('Int', key, value);

  Future<bool> setDouble(String key, double value) => _setValue('Double', key, value);

  Future<bool> setString(String key, String value) => _setValue('String', key, value);

  Future<bool> setStringList(String key, List<String> value) => _setValue('StringList', key, value);



  bool containsKey(String key) => _preferenceCache.containsKey(key);



  Future<bool> remove(String key) {
    _preferenceCache.remove(key);
    return _store.remove(key, filename);
  }



  Future<bool> _setValue(String valueType, String key, Object value) {

    // If value is a string list make a copy of it so that later mutations won't propagate.
    _preferenceCache[key] = (value is List<String>) ? value.toList() : value;

    return _store.setValue(valueType, key, value, filename);
  }



  Future<bool> clear() {
    _preferenceCache.clear();
    return _store.clear(filename);
  }



  Future<void> reload() async {
    final Map<String, Object> preferences = await _store.getAll(filename);
    _preferenceCache.clear();
    _preferenceCache.addAll(preferences);
  }
}