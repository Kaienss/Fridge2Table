/*
 * @Author: Jake 
 * @Date: 2023-03-21 12:58:29
 * @LastEditors: Jake 
 * @LastEditTime: 2023-09-25 21:46:08
 * @FilePath: /bingxiang/my_app/lib/src/prepare_screen.dart
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:my_app/components/animate_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_app/components/recipe_card.dart';
import 'package:my_app/services/router_service.dart';
import 'package:my_app/storage/local_storage.dart';
import 'package:my_app/utils/app_style.dart';
import 'package:my_app/utils/global.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class PrepareScreen extends StatefulWidget {
  const PrepareScreen({super.key});

  @override
  State<PrepareScreen> createState() => _PrepareScreenState();
}

class _PrepareScreenState extends State<PrepareScreen> {
  List recipes = []; //准备要做的菜谱list
  List prepares = []; //要准备做的事情
  var refrigeStorage = Global.refrigeStorage;
  var recipeData = Global.recipeData;

  @override
  void initState() {
    super.initState();
    setUp();
  }

  setUp() async {
    // 获取手机内存已储存的食材
    await LocalStorage.init();
    var list = LocalStorage.prefs?.getStringList('prepareRecipeIds') ?? [];
    for (var i = 0; i < list.length; i++) {
      for (var j = 0; j < recipeData.length; j++) {
        if (recipeData[j]['id'].toString() == list[i]) {
          recipes.add(recipeData[j]);
        }
      }
    }
    for (var i = 0; i < recipes.length; i++) {
      if (recipes[i]['prepare'] != null) {
        prepares.addAll(recipes[i]['prepare']);
      }
    }

    setState(() {
      recipes = recipes;
      prepares = prepares;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScrollViewWithAnimateAppBar(
      appBarTitleWidget: const Text('准备工作'),
      actions: [
        GestureDetector(
          onTap: () {
            _cleanAllPrepareStorage();
          },
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
        padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 120.r),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _showRecipes()));
  }

  _cleanAllPrepareStorage() {
    LocalStorage.prefs?.setStringList('prepareRecipeIds', []);
    setState(() {
      recipes = [];
      prepares = [];
    });
    EasyLoading.showToast('已清空');
  }

  _showRecipes() {
    List<Widget> list = [];
    if (recipes.isNotEmpty) {
      list.add(SizedBox(height: 5.r));
      list.add(Text(
        '菜谱',
        style: AppStyle.boldTextStyle(16.w),
      ));
      list.add(SizedBox(height: 20.r));
    }
    for (var i = 0; i < recipes.length; i++) {
      list.add(RecipeCard(
        onClickCard: () {
          if (recipes[i]['step'] != null && recipes[i]['step'].length != 0) {
            context.push(ScreenPath.detail.value,
                extra: {'step': recipes[i]['step'], 'recipe': recipes[i]});
          }
        },
        data: recipes[i],
        title: recipes[i]['name'],
        img: recipes[i]['img'] ?? '',
        hasStep: recipes[i]['step'] != null && recipes[i]['step'].length != 0,
        containNameArr: recipes[i]['mainFood'],
        canAddToCart: false,
      ));
    }

    //添加准备事项
    if (prepares.isNotEmpty) {
      list.add(SizedBox(height: 28.r));
      list.add(Text(
        '备菜需要',
        style: AppStyle.boldTextStyle(16.w),
      ));
      list.add(SizedBox(height: 20.r));
      for (var i = 0; i < prepares.length; i++) {
        list.add(Container(
          padding: EdgeInsets.only(top: 10.r),
          child: Row(
            children: [
              Container(
                width: 15.r,
                height: 15.r,
                padding: EdgeInsets.only(bottom: 1.5.r),
                margin: EdgeInsets.only(left: 11.w, right: 4.r),
                decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.all(Radius.circular(7.5.r))),
                child: Center(
                    child: Text(
                  (i + 1).toString(),
                  style: AppStyle.boldTextStyle(10.w)
                      .merge(const TextStyle(color: Colors.black)),
                )),
              ),
              SizedBox(
                width: 280.w,
                child: Text(prepares[i]),
              )
            ],
          ),
        ));
      }
    }
    return list;
  }

  // _addEffectToString(String text, List<String> foodsList) {
  //   for (var i = 0; i < foodsList.length; i++) {
  //     text = text.replaceAll(foodsList[i], '<red>${foodsList[i]}</red>');
  //   }
  //   return text;
  // }
}
