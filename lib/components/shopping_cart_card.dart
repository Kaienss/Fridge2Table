/*
 * @Author: Jake 
 * @Date: 2023-09-25 21:39:07
 * @LastEditors: Jake 
 * @LastEditTime: 2023-09-25 21:40:39
 * @FilePath: /bingxiang/my_app/lib/components/shopping_cart_card.dart
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_app/utils/app_style.dart';

class ShoppingCartCard extends StatefulWidget {
  final String name;
  final Function onClickDelete;
  final Function onClickBought;
  const ShoppingCartCard(
      {super.key,
      required this.name,
      required this.onClickDelete,
      required this.onClickBought});

  @override
  State<ShoppingCartCard> createState() => _ShoppingCartCardState();
}

class _ShoppingCartCardState extends State<ShoppingCartCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 10.r),
        child: Container(
          padding: EdgeInsets.only(left: 10.r, right: 10.r),
          width: double.infinity,
          height: 50.r,
          decoration: BoxDecoration(
            color: AppStyle.cardBgGrey,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Center(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                Text(widget.name),
                Row(
                  children: [
                    GestureDetector(
                        onTap: () => widget.onClickBought(),
                        child: Container(
                            height: double.infinity,
                            padding: EdgeInsets.only(left: 10.r, right: 10.r),
                            child: Center(
                                child: Text('已买',
                                    style: AppStyle.boldTextStyle(12.sp).merge(
                                        const TextStyle(
                                            color: Color.fromARGB(
                                                255, 145, 217, 139))))))),
                    SizedBox(width: 5.w),
                    GestureDetector(
                        onTap: () => widget.onClickDelete(),
                        child: Container(
                            height: double.infinity,
                            padding: EdgeInsets.only(left: 10.r, right: 10.r),
                            child: Center(
                                child: Text('删除',
                                    style: AppStyle.boldTextStyle(12.sp).merge(
                                        const TextStyle(
                                            color: AppStyle.systemRed))))))
                  ],
                )
              ])),
        ));
  }
}
