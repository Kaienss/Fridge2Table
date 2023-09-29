/*
 * @Author: Jake 
 * @Date: 2023-02-01 16:41:49
 * @LastEditors: Jake 
 * @LastEditTime: 2023-09-25 21:24:54
 * @FilePath: /bingxiang/my_app/lib/src/can_cook_screen.dart
 * @Description: 
 */
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:my_app/components/animate_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_app/components/recipe_card.dart';
import 'package:my_app/services/router_service.dart';
import 'package:my_app/storage/local_storage.dart';
import 'package:my_app/utils/global.dart';
import 'package:my_app/utils/app_style.dart';
import 'package:my_app/utils/tools.dart';
import 'package:collection/collection.dart';

class CanCookScreen extends StatefulWidget {
  const CanCookScreen({super.key});

  @override
  State<CanCookScreen> createState() => _CanCookScreenState();
}

class _CanCookScreenState extends State<CanCookScreen>
    with _CanCookScreenStateMixin {
  @override
  void initState() {
    super.initState();
    _getResultRecipe(refrigeStorage);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabBarTitleList.length + 1, //带着一个标题占一个位置
      child: ScrollViewWithAnimateAppBar(
        key: scrollViewKey,
        appBarTitleWidget:
            Text('当前可以做的菜谱', style: AppStyle.boldTextStyle(16.w)),
        lightModeColorTweenStart: Colors.white,
        isLightMode: true, //目前此页没有dark mode
        hasBottomWidget: true,
        hasFloatBtn: true,
        lightModeShadowColorTweenEnd: AppStyle.whiteTransparent, //取消shadow动态变化
        darkModeShadowColorTweenEnd: Colors.transparent, //取消shadow动态变化
        bottomWidget: PreferredSize(
          preferredSize: const Size(0, 0), //必须要给，但又没有用到
          child: Container(
              padding: EdgeInsets.zero,
              alignment: Alignment.topLeft,
              child: _tabBar()),
        ),
        bodyWidget: _scrollViewBody(),
        onRefresh: () {
          debugPrint('下拉刷新');
        },
      ),
    );
  }

  PreferredSizeWidget _tabBar() {
    return (TabBar(
        labelPadding: EdgeInsets.only(right: 10.w, bottom: 10.r),
        isScrollable: true,
        padding: EdgeInsets.zero,
        indicatorPadding: EdgeInsets.zero,
        indicatorColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.label,
        onTap: (int int) {
          if (int != 0) {
            setState(() {
              selectedIndex = int - 1; //有个标签位置
            });
            scrollViewKey.currentState?.scrollToTop();
          }
        },
        tabs: _tabs()));
  }

  List<Widget> _tabs() {
    List<Widget> list = [
      Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: Text(
            '分类',
            style: AppStyle.boldTextStyle(16.sp)
                .merge(const TextStyle(color: AppStyle.textColorBlack)),
          ))
    ];
    for (var i = 0; i < tabBarTitleList.length; i++) {
      list.add(_tabBarButton(selectedIndex == i, tabBarTitleList[i], i));
    }
    return list.toList();
  }

  Widget _tabBarButton(bool isSelected, String text, int index) {
    return (Tab(
      child: Container(
          height: 29.w,
          padding: EdgeInsets.only(left: 13.w, right: 13.w),
          decoration: BoxDecoration(
            color: isSelected
                // ? const Color(0xFF15131E)
                ? AppStyle.primaryColor
                : const Color(0xFFEAEAEA),
            borderRadius: BorderRadius.circular(14.5.w),
          ),
          child: Center(
              child: Text(
            text,
            style: AppStyle.boldTextStyle(12.sp).merge(TextStyle(
              color: isSelected ? Colors.white : const Color(0xFFAFB2B6),
            )),
          ))),
    ));
  }

  Widget _scrollViewBody() {
    return Padding(
        padding:
            EdgeInsets.only(left: 20.r, right: 20.r, top: 5.r, bottom: 120.r),
        child: tabBarTitleList.isEmpty
            ? const SizedBox()
            : _canCookRecipeList(tabBarTitleList[selectedIndex]));
  }

  // 搜索结果，完全匹配可做的
  Widget _canCookRecipeList(type) {
    return Column(
        children: canCookRecipeArr
            .mapIndexed((index, item) => item['type'] == type
                ? RecipeCard(
                    onClickCard: () => _onClickRecipeCard(index),
                    data: item,
                    title: item['name'],
                    img: item['img'] ?? '',
                    hasStep: item['step'] != null && item['step'].length != 0,
                    containNameArr: item['mainFood'],
                    canAddToCart: false,
                  )
                : const SizedBox())
            .toList());
  }
}

mixin _CanCookScreenStateMixin<T extends StatefulWidget> on State<T> {
  List canCookRecipeArr = []; //食谱list
  List<String> refrigeNameArr = []; //冰箱有的食材名字
  int selectedIndex = 0; //分类index
  List<Map> refrigeStorage = Global.refrigeStorage;
  List<Map> globalRecipeData = Global.recipeData;
  List<String> tabBarTitleList = [];

  //获取所有食谱
  _getResultRecipe(allRefrigeStorage) async {
    //冰箱里有的食材
    await LocalStorage.init();
    var list = LocalStorage.prefs?.getStringList('refrigeStorage');
    if (list != null) {
      for (var i = 0; i < list.length; i++) {
        for (var j = 0; j < refrigeStorage.length; j++) {
          if (refrigeStorage[j]['name'] == list[i]) {
            refrigeStorage[j]['isSelected'] = true;
            refrigeNameArr.add(refrigeStorage[j]['name']);
          }
        }
      }
    }
    // 获取能做的食谱
    for (var i = 0; i < globalRecipeData.length; i++) {
      if (Tools.isSubsetOrNot(
          globalRecipeData[i]['mainFood'] as List, refrigeNameArr)) {
        canCookRecipeArr.add(globalRecipeData[i]);
      }
    }
    // 获取分类
    for (var item in canCookRecipeArr) {
      tabBarTitleList.add(item['type']);
    }
    setState(() {
      canCookRecipeArr = canCookRecipeArr;
      tabBarTitleList = tabBarTitleList.toSet().toList();
    });
  }

  _onClickRecipeCard(int i) {
    if (canCookRecipeArr[i]['step'] != null &&
        canCookRecipeArr[i]['step'].length != 0) {
      context.push(ScreenPath.detail.value, extra: {
        'step': canCookRecipeArr[i]['step'],
        'recipe': canCookRecipeArr[i],
      });
    }
  }
}
