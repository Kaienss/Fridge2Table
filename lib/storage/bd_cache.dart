/*
 * @Author: Jake 
 * @Date: 2023-01-07 18:58:51
 * @LastEditors: Jake 
 * @LastEditTime: 2023-08-23 17:28:48
 * @FilePath: /bingxiang/my_app/lib/storage/bd_cache.dart
 * @Description: 
 */
import 'local_storage.dart';

class BDCache<T> {
  String key;
  T defaultValue;

  BDCache({required this.key, required this.defaultValue});

  T get value {
    var result = LocalStorage.prefs?.get(key);
    if (result == null) {
      return defaultValue;
    }
    return result as T;
  }

  set value(T newValue) {
    if (newValue is bool) {
      LocalStorage.prefs?.setBool(key, newValue);
      return;
    }

    if (newValue is int) {
      LocalStorage.prefs?.setInt(key, newValue);
      return;
    }

    if (newValue is double) {
      LocalStorage.prefs?.setDouble(key, newValue);
      return;
    }

    if (newValue is String) {
      LocalStorage.prefs?.setString(key, newValue);
      return;
    }

    if (newValue is List<String>) {
      LocalStorage.prefs?.setStringList(key, newValue);
      return;
    }
  }

  removeValue() async {
    await LocalStorage.prefs?.remove(key);
  }
}
