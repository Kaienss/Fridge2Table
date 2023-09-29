/*
 * @Author: Jake 
 * @Date: 2022-10-07 15:54:23
 * @LastEditors: Jake 
 * @LastEditTime: 2023-09-25 21:26:02
 * @FilePath: /bingxiang/my_app/lib/src/tabs.dart
 * @Description: 
 */
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_app/src/can_cook_screen.dart';
import 'package:my_app/src/cannot_cook_screen.dart';
import 'package:my_app/src/prepare_screen.dart';
import 'package:my_app/src/refrigerator_storage_screen.dart';
import 'package:my_app/src/shopping_cart_screen.dart';
import 'package:my_app/utils/app_style.dart';

class Tabs extends StatefulWidget {
  final int initIndex;
  const Tabs({super.key, this.initIndex = 0});
  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  final iconSize = 35.0;
  int currentIndex = 0;
  List<Widget> pages = const [
    CanCookScreen(),
    ShoppingCartScreen(),
    RefrigeratorStorageScreen(),
    CannotCookScreen(),
    PrepareScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 5, //带着一个标题占一个位置
        child: Scaffold(
            extendBody: true,
            body: pages[currentIndex],
            // 如果不想每次刷新 用下面这种写法
            //     IndexedStack(
            //   index: currentIndex,
            //   children: pages,
            // ),
            bottomNavigationBar: menu()));
  }

  Widget menu() {
    return Container(
      color: Colors.white,
      child: TabBar(
        labelColor: AppStyle.primaryColor,
        unselectedLabelColor: AppStyle.textColorGrey,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.all(5.w),
        indicatorColor: Colors.transparent,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        tabs: const [
          Tab(
            text: "首页",
            icon: Icon(Icons.home),
          ),
          Tab(
            text: "购物",
            icon: Icon(Icons.shopping_cart),
          ),
          Tab(
            text: "冰箱",
            icon: Icon(Icons.account_balance_wallet),
          ),
          Tab(
            text: "菜谱",
            icon: Icon(Icons.auto_stories),
          ),
          Tab(
            text: "准备",
            icon: Icon(Icons.outdoor_grill),
          ),
        ],
      ),
    );
  }
}
