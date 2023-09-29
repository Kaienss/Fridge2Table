/*
 * @Author: Jake 
 * @Date: 2022-12-23 12:09:20
 * @LastEditors: Jake 
 * @LastEditTime: 2023-09-25 20:45:57
 * @FilePath: /bingxiang/my_app/lib/main.dart
 * @Description: 
 */
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_app/services/router_service.dart';
import 'package:my_app/utils/app_style.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  setup();
  runApp(const MyApp());
}

setup() async {}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            title: "BINGXIANG",
            debugShowCheckedModeBanner: false,
            routerConfig: RouterService.router,
            theme: AppStyle.appThemeData(),
            builder: EasyLoading.init(),
          );
        });
  }
}
