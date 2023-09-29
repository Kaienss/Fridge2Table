/*
 * @Author: Jake 
 * @Date: 2023-01-07 18:57:12
 * @LastEditors: Jake 
 * @LastEditTime: 2023-01-07 18:59:36
 * @FilePath: /bingxiang/my_app/lib/storage/local_storage.dart
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:my_app/storage/bd_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage._private();

  static SharedPreferences? prefs;

  static init() async {
    LocalStorage.prefs = await SharedPreferences.getInstance();
    // AppStyle.defaultMapMarker = await BitmapDescriptor.fromAssetImage(
    //     const ImageConfiguration(size: Size(28, 35)),
    //     'assets/images/location_pin.png');
    // AppStyle.highlightMapMarker = await BitmapDescriptor.fromAssetImage(
    //     const ImageConfiguration(size: Size(28, 35)),
    //     'assets/images/location_pin_highlight.png');
  }

  static BDCache<bool> firstInstall = BDCache(
    key: 'FIRST_INSTALL',
    defaultValue: true,
  );
}
