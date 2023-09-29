/*
 * @Author: Jake 
 * @Date: 2022-11-07 17:34:00
 * @LastEditors: Jake 
 * @LastEditTime: 2023-08-30 16:01:25
 * @FilePath: /bingxiang/my_app/lib/components/gradient_button.dart
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_app/utils/app_style.dart';

class GradientButton extends StatelessWidget {
  final String title;
  final double height;
  final double width;
  final List<Color> backgroundColors;
  final Color titleColor;
  final Function onPressed;
  final double paddingHorizontal;
  final double paddingVertical;
  final Widget iconWidget;
  final bool isCenter; //是否居中显示button内容
  final double titleFontSize;
  const GradientButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.height = 42,
    this.width = 0, //初始化 width给0 表示double.infinity
    this.paddingHorizontal = 17,
    this.paddingVertical = 0,
    this.titleColor = AppStyle.textColorBlack,
    this.backgroundColors = AppStyle.primaryGradient,
    this.iconWidget = const SizedBox(),
    this.isCenter = true,
    this.titleFontSize = 0, //为0时默认值为14.sp大小
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          height: height,
          // width: width == 0 ? double.infinity : width,
          width: width == 0 ? null : width,
          padding: EdgeInsets.fromLTRB(
              width == 0 ? paddingHorizontal : 0,
              paddingVertical,
              width == 0 ? paddingHorizontal : 0,
              paddingVertical),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: backgroundColors),
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: Row(
            mainAxisAlignment:
                isCenter ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              iconWidget,
              Text(
                title,
                style: AppStyle.boldTextStyle(
                        titleFontSize == 0 ? 14.sp : titleFontSize)
                    .merge(TextStyle(color: titleColor)),
              ),
            ],
          )),
      onTap: () {
        onPressed();
      },
    );
  }
}
