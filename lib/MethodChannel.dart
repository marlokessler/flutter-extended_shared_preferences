
import 'package:flutter/services.dart';



const MethodChannel _kChannel = MethodChannel('com.marlokessler.sharedpreferences');



class MethodChannelSharedPreferencesStore {



  MethodChannelSharedPreferencesStore._();

  static MethodChannelSharedPreferencesStore instance = MethodChannelSharedPreferencesStore._();



  Future<Map<String, Object>> getAll(String filename) => _kChannel.invokeMapMethod<String, Object>( 'getAll', <String, dynamic>{ 'filename': filename });

  Future<bool> setValue(String valueType, String key, Object value, String filename) => _invokeBoolMethod('set$valueType', <String, dynamic>{ 'key': key, 'value': value, 'filename': filename });

  Future<bool> clear(String filename) => _kChannel.invokeMethod<bool>('clear', <String, dynamic>{ 'filename': filename });

  Future<bool> remove(String key, String filename) => _invokeBoolMethod('remove', <String, dynamic>{  'key': key, 'filename': filename });



  Future<bool> _invokeBoolMethod(String method, Map<String, dynamic> params) => _kChannel
                                                                                .invokeMethod<bool>(method, params)
                                                                                .then<bool>((dynamic result) => result);
}
