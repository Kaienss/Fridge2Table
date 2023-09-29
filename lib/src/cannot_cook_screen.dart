/*
 * @Author: Jake 
 * @Date: 2023-01-06 13:56:35
 * @LastEditors: Jake 
 * @LastEditTime: 2023-09-25 21:50:08
 * @FilePath: /bingxiang/my_app/lib/src/cannot_cook_screen.dart
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_app/components/animate_app_bar.dart';
import 'package:my_app/components/gradient_button.dart';
import 'package:my_app/components/recipe_card.dart';
import 'package:my_app/services/router_service.dart';
import 'package:my_app/storage/local_storage.dart';
import 'package:my_app/utils/global.dart';
import 'package:my_app/utils/app_style.dart';
import 'package:my_app/utils/constants.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:go_router/go_router.dart';
import 'package:my_app/utils/tools.dart';

class CannotCookScreen extends StatefulWidget {
  const CannotCookScreen({super.key});

  @override
  State<CannotCookScreen> createState() => _CannotCookScreenState();
}

class _CannotCookScreenState extends State<CannotCookScreen> {
  List resultArr = [];
  List resultVagueArr = [];
  List refrigeNameArr = [];
  int selectedIndex = 0;
  List nonHaveArr = []; //啥材料都没有
  List typeArr = [
    {'name': '主食', 'isSelected': true},
    {'name': '蔬菜', 'isSelected': false},
    {'name': '肉类', 'isSelected': false},
    {'name': '中性', 'isSelected': false},
    // {'name': '凉菜', 'isSelected': false},
    {'name': '零食', 'isSelected': false},
    {'name': '减脂', 'isSelected': false},
    {'name': '汤类', 'isSelected': false},
    {'name': '凉菜', 'isSelected': false},
    {'name': '甜品', 'isSelected': false},
  ];
  String selectedType = '主食';
  List tabBarTitleList = [];
  TextEditingController _textField = TextEditingController();
  List<Widget> showDataList = [];

  var refrigeStorage = Global.refrigeStorage;
  var recipeData = Global.recipeData;
  @override
  void initState() {
    super.initState();

    setUp();
  }

  setUp() async {
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
    getResultRecipe(refrigeStorage);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabBarTitleList.length + 1, //带着一个标题占一个位置
      child: ScrollViewWithAnimateAppBar(
        key: scrollViewKey,
        // hasBackBtn: true,
        appBarTitleWidget: Text('缺少材料的菜谱', style: AppStyle.boldTextStyle(16.w)),
        lightModeColorTweenStart: Colors.white,
        // leadingWidthOfTitleInAppBar: 20.w,
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
        bodyWidget: _scrollView(),
        onRefresh: () {},
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
          for (var j = 0; j < typeArr.length; j++) {
            if (j == int - 1) {
              setState(() {
                typeArr[j]['isSelected'] = true;
                selectedType = typeArr[j]['name'] as String;
              });
            } else {
              setState(() {
                typeArr[j]['isSelected'] = false;
              });
            }
          }
          if (int != 0) {
            setState(() {
              selectedIndex = int - 1; //有个标签位置
            });
            scrollViewKey.currentState?.scrollToTop();
          }
          getShowListData();
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
            color: isSelected ? AppStyle.primaryColor : const Color(0xFFEAEAEA),
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

  Widget _scrollView() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 50.w,
          margin: EdgeInsets.fromLTRB(20.w, 10.w, 20.w, 9),
          padding: EdgeInsets.only(left: 20.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.w),
              color: Colors.white,
              border: Border.all(color: AppStyle.cardBgGrey, width: 2.0)),
          child: TextField(
              onChanged: (text) => onSearch(text),
              controller: _textField,
              decoration: InputDecoration(
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  counterText: '',
                  hintStyle: AppStyle.regularTextStyle(16.w)
                      .merge(const TextStyle(color: AppStyle.textColorBlack)))),
        ),
        Padding(
            padding: EdgeInsets.only(
                left: 20.w, right: 20.w, top: 5.r, bottom: 120.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15.r),
                Column(children: showDataList),
                // resultVagueRecipe(selectedType),
                SizedBox(
                  height: 150.r,
                )
              ],
            ))
      ],
    );
  }

  List<Widget> typeVagueButtons() {
    List<Widget> list = [];
    for (var i = 0; i < typeArr.length; i++) {
      list.add(Padding(
          padding: EdgeInsets.only(right: 4.w),
          child: GestureDetector(
            onTap: () {
              for (var j = 0; j < typeArr.length; j++) {
                if (j == i) {
                  setState(() {
                    typeArr[j]['isSelected'] = true;
                    selectedType = typeArr[j]['name'] as String;
                  });
                } else {
                  setState(() {
                    typeArr[j]['isSelected'] = false;
                  });
                }
              }
            },
            child: Container(
                padding: EdgeInsets.fromLTRB(5.w, 3.r, 5.w, 3.r),
                decoration: BoxDecoration(
                  color: typeArr[i]['isSelected'] as bool
                      ? AppStyle.primaryColor
                      : AppStyle.cardBgGrey,
                  borderRadius: BorderRadius.circular(3.r),
                ),
                child: Text(typeArr[i]['name'] as String)),
          )));
    }
    return list;
  }

  // 搜索结果，模糊匹配，有的食材缺少
  // Widget resultVagueRecipe(selectedType) {
  //   return;
  // }

  void getShowListData() {
// (_textField.text != '' &&
//               resultVagueArr[i]['name'].contains(_textField.value))
    showDataList = [];
    for (var i = 0; i < resultVagueArr.length; i++) {
      if (resultVagueArr[i]['type'] == selectedType) {
        if (_textField.text != '' &&
            !resultVagueArr[i]['name'].contains(_textField.text)) {
          continue;
        }
        List<String> containNameArr = [];
        List<String> unContainNameArr = [];
        for (var j = 0;
            j < (resultVagueArr[i]['mainFood'] as List).length;
            j++) {
          if (refrigeNameArr.contains(resultVagueArr[i]['mainFood'][j])) {
            containNameArr.add(resultVagueArr[i]['mainFood'][j]);
          } else {
            unContainNameArr.add(resultVagueArr[i]['mainFood'][j]);
          }
        }
        List<Widget> containList = [
          Text(
            '包含：',
            style: AppStyle.boldTextStyle(12.sp),
          )
        ];
        List<Widget> unContainList = [
          Text(
            '缺少：',
            style: AppStyle.boldTextStyle(12.sp),
          )
        ];
        for (var i = 0; i < containNameArr.length; i++) {
          containList.add(Padding(
              padding: EdgeInsets.only(right: 5.w),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFA9B7AA),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: Center(
                    child: Padding(
                  padding: EdgeInsets.fromLTRB(5.w, 2.r, 5.w, 2.r),
                  child: Text(
                    containNameArr[i],
                    style: AppStyle.regularTextStyle(12.sp),
                  ),
                )),
              )));
        }
        for (var i = 0; i < unContainNameArr.length; i++) {
          unContainList.add(Padding(
              padding: EdgeInsets.only(right: 5.w),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFE2C6C4),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: Center(
                    child: Padding(
                  padding: EdgeInsets.fromLTRB(5.w, 2.r, 5.w, 2.r),
                  child: Text(
                    unContainNameArr[i],
                    style: AppStyle.regularTextStyle(12.sp),
                  ),
                )),
              )));
        }

        showDataList.add(RecipeCard(
          onClickCard: () {
            if (resultVagueArr[i]['step'] != null &&
                resultVagueArr[i]['step'].length != 0) {
              context.push(ScreenPath.detail.value, extra: {
                'step': resultVagueArr[i]['step'],
                'recipe': resultVagueArr[i]
              });
            }
          },
          data: resultVagueArr[i],
          title: resultVagueArr[i]['name'],
          img: resultVagueArr[i]['img'] ?? '',
          containNameArr: containNameArr,
          hasStep: resultVagueArr[i]['step'] != null &&
              resultVagueArr[i]['step'].length != 0,
          unContainNameArr: unContainNameArr,
          canAddToCart: true,
        ));
      }
    }
    setState(() {
      showDataList = showDataList;
    });
  }

  // _addItemToShoppingCart(unContainNameArr) {
  //   List<String> list = LocalStorage.prefs?.getStringList('shoppingCart') ?? [];
  //   list.addAll(unContainNameArr);
  //   list.toSet().toList();
  //   LocalStorage.prefs?.setStringList('shoppingCart', list);
  //   EasyLoading.showToast('已添加至购物车');
  // }

  getResultRecipe(allRefrigeStorage) {
    resultArr = [];
    resultVagueArr = [];
    refrigeNameArr = [];
    for (var i = 0; i < allRefrigeStorage.length; i++) {
      if (allRefrigeStorage[i]['isSelected'] as bool) {
        refrigeNameArr.add(allRefrigeStorage[i]['name']);
      }
    }
    for (var i = 0; i < recipeData.length; i++) {
      if (Tools.isSubsetOrNot(
          recipeData[i]['mainFood'] as List, refrigeNameArr)) {
        resultArr.add(recipeData[i]);
      } else if (Tools.isVagueSubset(
          recipeData[i]['mainFood'] as List, refrigeNameArr)) {
        resultVagueArr.add(recipeData[i]);
      }
    }
    setState(() {
      resultArr = resultArr;
      resultVagueArr = resultVagueArr;
      refrigeNameArr = refrigeNameArr;
    });

    var showTitleList = [];
    var typeArrList = [];
    for (var i = 0; i < typeArr.length; i++) {
      typeArrList.add(typeArr[i]['name']);
    }
    for (var i = 0; i < resultArr.length; i++) {
      if (typeArrList.contains(resultArr[i]['type'])) {
        showTitleList.add(resultArr[i]['type']);
      }
    }
    showTitleList = showTitleList.toSet().toList();
    for (var i = 0; i < typeArr.length; i++) {
      tabBarTitleList.add(typeArr[i]['name']);
      // if (showTitleList.contains(typeArr[i]['name'])) {
      //   tabBarTitleList.add(typeArr[i]['name']);
      // }
    }

    setState(() {
      tabBarTitleList = tabBarTitleList;
    });
    getShowListData();
  }

  onSearch(String text) {
    getShowListData();
  }
}
