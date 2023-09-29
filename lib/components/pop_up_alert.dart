/*
 * @Author: Jake 
 * @Date: 2023-01-18 17:44:19
 * @LastEditors: Jake 
 * @LastEditTime: 2023-03-20 15:31:21
 * @FilePath: /bingxiang/my_app/lib/components/pop_up_alert.dart
 * @Description: 
 */
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_app/utils/app_style.dart';

class PopUpAlert extends StatefulWidget {
  final String title;
  final String desp;
  final Function onPressLeft;
  final Function onPressRight;
  const PopUpAlert(
      {super.key,
      required this.title,
      this.desp = '',
      required this.onPressLeft,
      required this.onPressRight});

  @override
  State<PopUpAlert> createState() => _PopUpAlertState();
}

class _PopUpAlertState extends State<PopUpAlert> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          _blurBackground(),
          _mainContentCard(),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                child: Text('test'),
              ))
        ],
      ),
    );
  }

  Widget _blurBackground() {
// Blur图层
    return Positioned(
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: const SizedBox(
            height: double.infinity,
            width: double.infinity,
          ),
        ));
  }

  Widget _mainContentCard() {
    return Container(
      height: 276.r,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(34.w, 37.r, 34.r, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFEBECF4),
            Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          widget.title,
          // 'Changed Your Mind?',
          style: AppStyle.boldTextStyle(20.sp),
        ),
        SizedBox(height: 40.r),
        Text(
          widget.desp,
          // 'Sure, we will cancel your collecting.',
          style: AppStyle.regularTextStyle(16.sp),
        ),
      ]),
    );
  }
}
