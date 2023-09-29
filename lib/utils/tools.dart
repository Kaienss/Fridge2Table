/*
 * @Author: Jake 
 * @Date: 2023-03-20 13:09:56
 * @LastEditors: Jake 
 * @LastEditTime: 2023-03-24 18:24:11
 * @FilePath: /bingxiang/my_app/lib/utils/tools.dart
 * @Description: 
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Tools {
  // 把当前时间戳转换成 YYYY-MM-DD 格式
  static String formatTimestamp(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  //判断arr1 是否是arr2 的子集
  static bool isSubsetOrNot(List arr1, List arr2) {
    bool result = true;

    for (var item in arr1) {
      if (!arr2.contains(item)) {
        result = false;
      }
    }
    return result;
  }

  //模糊查询： 判断arr1 是否含有arr2 的内容
  static bool isVagueSubset(List arr1, List arr2) {
    bool result = false;
    for (var item in arr1) {
      // 但凡有一个不包含 显示所有
      if (!arr2.contains(item)) {
        result = true;
      }
      // 部分包含
      // if (arr2.contains(item)) {
      //   result = true;
      // }
    }
    return result;
  }
}
