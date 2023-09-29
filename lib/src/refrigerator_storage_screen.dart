/*
 * @Author: Jake 
 * @Date: 2023-03-20 12:45:31
 * @LastEditors: Jake 
 * @LastEditTime: 2023-09-25 21:51:31
 * @FilePath: /bingxiang/my_app/lib/src/refrigerator_storage_screen.dart
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_app/components/animate_app_bar.dart';
import 'package:my_app/storage/local_storage.dart';
import 'package:my_app/utils/global.dart';
import 'package:my_app/utils/app_style.dart';
import 'package:my_app/utils/tools.dart';

class RefrigeratorStorageScreen extends StatefulWidget {
  const RefrigeratorStorageScreen({super.key});

  @override
  State<RefrigeratorStorageScreen> createState() =>
      _RefrigeratorStorageScreenState();
}

class _RefrigeratorStorageScreenState extends State<RefrigeratorStorageScreen>
    with _RefrigeratorStorageScreenStateMixin {
  @override
  void initState() {
    super.initState();
    setUp();
  }

  setUp() async {
    // 获取手机内存已储存的食材
    await LocalStorage.init();
    var list = LocalStorage.prefs?.getStringList('refrigeStorage');
    if (list != null) {
      for (var i = 0; i < list.length; i++) {
        for (var j = 0; j < refrigeStorage.length; j++) {
          if (refrigeStorage[j]['name'] == list[i]) {
            refrigeStorage[j]['isSelected'] = true;
          }
        }
      }
    }
    setState(() {
      refrigeStorage = refrigeStorage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScrollViewWithAnimateAppBar(
      appBarTitleWidget: const Text('冰箱库存'),
      actions: [
        GestureDetector(
          onTap: () => onTapClearAll(),
          child: Container(
              padding: EdgeInsets.only(right: 20.w, left: 15.w),
              child: Center(
                child: Text(
                  '清空',
                  style: AppStyle.boldTextStyle(14.w),
                ),
              )),
        )
      ],
      lightModeColorTweenStart: Colors.white,
      hasBackBtn: false,
      leadingWidthOfTitleInAppBar: 20.w,
      isLightMode: true,
      bodyWidget: _scrollView(),
      onRefresh: () {},
    );
  }

  _scrollView() {
    return Padding(
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5.w),
            SizedBox(height: 10.r),
            Text('主食', style: AppStyle.boldTextStyle(14.w)),
            SizedBox(height: 8.r),
            refrigeFoods(type: '主食'),
            SizedBox(height: 12.w),
            Text('蔬菜', style: AppStyle.boldTextStyle(14.w)),
            SizedBox(height: 8.r),
            refrigeFoods(type: '蔬菜'),
            SizedBox(height: 12.w),
            Text('肉类', style: AppStyle.boldTextStyle(14.w)),
            SizedBox(height: 8.r),
            refrigeFoods(type: '肉类'),
            SizedBox(height: 12.w),
            Text('中性', style: AppStyle.boldTextStyle(14.w)),
            SizedBox(height: 8.r),
            refrigeFoods(type: '中性'),
            SizedBox(height: 12.w),
            Text('配料', style: AppStyle.boldTextStyle(14.w)),
            SizedBox(height: 8.r),
            refrigeFoods(type: '配料'),
            SizedBox(height: 12.w),
            Text('水果', style: AppStyle.boldTextStyle(14.w)),
            SizedBox(height: 8.r),
            refrigeFoods(type: '水果'),
            SizedBox(height: 12.w),
            Text('奶制品', style: AppStyle.boldTextStyle(14.w)),
            SizedBox(height: 8.r),
            refrigeFoods(type: '奶制品'),
            SizedBox(height: 12.w),
            SizedBox(height: 120.r),
          ],
        ));
  }

// 所有食材，选中的为冰箱目前有的食材
  Widget refrigeFoods({required String type}) {
    List<Widget> list = [];
    for (var i = 0; i < refrigeStorage.length; i++) {
      if (refrigeStorage[i]['type'] == type) {
        list.add(Padding(
            padding: EdgeInsets.only(right: 5.w),
            child: GestureDetector(
              onTap: () => onClickWrapItem(refrigeStorage[i]),
              child: Container(
                  padding: EdgeInsets.fromLTRB(5.w, 3.r, 5.w, 3.r),
                  decoration: BoxDecoration(
                    color: refrigeStorage[i]['isSelected'] as bool
                        ? AppStyle.primaryColor
                        : AppStyle.cardBgGrey,
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                  child: Text(refrigeStorage[i]['name'] as String)),
            )));
      }
    }
    return Wrap(
      spacing: 2,
      runSpacing: 5,
      children: list,
    );
  }
}

mixin _RefrigeratorStorageScreenStateMixin<T extends StatefulWidget>
    on State<T> {
  List<Map> refrigeStorage = Global.refrigeStorage;

  onClickWrapItem(item) async {
    setState(() {
      bool b = item['isSelected'] as bool;
      item['isSelected'] = !b;
    });
    List<String> storNameList = [];
    for (var i = 0; i < refrigeStorage.length; i++) {
      if (refrigeStorage[i]['isSelected'] == true) {
        storNameList.add(refrigeStorage[i]['name'] as String);
      }
    }
    LocalStorage.prefs?.setStringList('refrigeStorage', storNameList);
  }

  onTapClearAll() {
    LocalStorage.prefs?.remove('refrigeStorage');
    for (var item in refrigeStorage) {
      item['isSelected'] = false;
    }
    setState(() {
      refrigeStorage = refrigeStorage;
    });
  }
}
