/*
 * @Author: Jake 
 * @Date: 2023-03-20 15:14:37
 * @LastEditors: Jake 
 * @LastEditTime: 2023-03-20 15:38:24
 * @FilePath: /bingxiang/my_app/lib/components/pop_up_view.dart
 * @Description: 
 */
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_app/utils/app_style.dart';

class PopUpView extends StatefulWidget {
  final Widget child;
  const PopUpView({super.key, required this.child});

  @override
  State<PopUpView> createState() => _PopUpViewState();
}

class _PopUpViewState extends State<PopUpView> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [_blurBackground(), _contentWidget()],
      ),
    );
  }

  Widget _contentWidget() {
    return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Column(
          children: [
            _closeButton(),
            _mainContentCard(),
          ],
        ));
  }

  Widget _mainContentCard() {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Padding(
            padding: EdgeInsets.fromLTRB(22.r, 23.r, 18.r, 40.r),
            child: Column(
              children: [widget.child],
            )));
  }

  Widget _closeButton() {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
            height: 40.r,
            padding: EdgeInsets.only(bottom: 10.r, right: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(
                  Icons.close,
                  color: Color(0xFFD9D9D9),
                  size: 21,
                ),
                SizedBox(width: 10.w),
                Text(
                  'Close',
                  style: AppStyle.mediumTextStyle(16.w)
                      .merge(const TextStyle(color: Color(0xFFD9D9D9))),
                ),
              ],
            )));
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
}
