/*
 * @Author: Jake 
 * @Date: 2022-10-05 16:15:07
 * @LastEditors: Jake 
 * @LastEditTime: 2023-08-30 16:20:26
 * @FilePath: /bingxiang/my_app/lib/utils/app_style.dart
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'material_color_generator.dart';

class AppStyle {
  //theme
  static ThemeData appThemeData() {
    var textTheme = const TextTheme()
        .apply(bodyColor: textColorBlack, displayColor: textColorBlack);
    var theme = ThemeData(
        colorScheme: ColorScheme.fromSwatch(
            primarySwatch: generateMaterialColor(color: primaryColor)),
        fontFamily: 'Montserrat',
        fontFamilyFallback: const [
          'PingFang-Regular',
          'PingFang-Thin',
          'PingFang-ExtraLight',
          'PingFang-Light',
          'PingFang-Regular',
          'PingFang-Medium',
          'PingFang-SemiBold',
        ],
        textTheme: textTheme,
        highlightColor: Colors.transparent, //取消涟漪效应
        splashColor: Colors.transparent, //取消涟漪效应
        appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
                fontSize: 16,
                color: textColorBlack,
                fontWeight: FontWeight.bold)));
    return theme;
  }

  //Colors
  static const primaryColor = Color(0xFF5C8B3E);
  static const systemRed = Color(0xFFDE562C);
  static const systemOriange = Color(0xFFF1B531);
  static const systemGreen = Color(0xFF5C8B3E);
  static const textColorGrey = Color(0xFFCCD4DE);
  static const textColorBlack = Color(0xFF1C2D33);
  static const cardBgGrey = Color(0xFFF6F6F6);
  static const borderGrey = Color(0xFFECECEC);
  static const backgroundBlack = Color(0xFF15131E);
  static const backgroundBlackTransparent = Color(0x0015131E);
  static const whiteTransparent = Color(0x00FFFFFF);
  static const primaryGradient = [Color(0xFFA4BE5F), Color(0xFF7EA055)];

  static TextStyle BlackTextStyle(double size, {Color color = textColorBlack}) {
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w900,
      color: color,
      height: 1.1,
    );
  }

  static TextStyle extraBoldTextStyle(double size,
      {Color color = textColorBlack}) {
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w800,
      color: color,
      height: 1.1,
    );
  }

  static TextStyle boldTextStyle(double size, {Color color = textColorBlack}) {
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w700,
      color: color,
      height: 1.1,
    );
  }

  static TextStyle semiBoldTextStyle(double size,
      {Color color = textColorBlack}) {
    return TextStyle(
        fontSize: size,
        // fontWeight: FontWeight.w600,
        color: color,
        height: 1.1,
        fontFamily: 'PingFang-SemiBold');
  }

  static TextStyle mediumTextStyle(double size,
      {Color color = textColorBlack}) {
    return TextStyle(
        fontSize: size,
        // fontWeight: FontWeight.w500,
        color: color,
        height: 1.1,
        fontFamily: 'PingFang-Medium');
  }

  static TextStyle regularTextStyle(double size,
      {Color color = textColorBlack}) {
    return TextStyle(
        fontSize: size,
        // fontWeight: FontWeight.w400,
        color: color,
        height: 1.1,
        fontFamily: 'PingFangR-Regular');
  }

  static TextStyle lightTextStyle(double size, {Color color = textColorBlack}) {
    return TextStyle(
        fontSize: size,
        // fontWeight: FontWeight.w300,
        color: color,
        height: 1.1,
        fontFamily: 'PingFang-Light');
  }

  static TextStyle extraLightTextStyle(double size,
      {Color color = textColorBlack}) {
    return TextStyle(
        fontSize: size,
        // fontWeight: FontWeight.w200,
        color: color,
        height: 1.1,
        fontFamily: 'PingFang-ExtraLight');
  }

  static TextStyle thinTextStyle(double size, {Color color = textColorBlack}) {
    return TextStyle(
        fontSize: size,
        // fontWeight: FontWeight.w100,
        color: color,
        height: 1.1,
        fontFamily: 'PingFang-Thin');
  }

  //spacing
  static EdgeInsets defaultPadding = EdgeInsets.all(24.w);
  static EdgeInsets smallPaddingAll = EdgeInsets.all(20.w);
  static EdgeInsets smallPaddingHorizontal =
      EdgeInsets.fromLTRB(20.r, 0, 20.r, 0);
}
