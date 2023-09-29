/*
 * @Author: Jake 
 * @Date: 2023-02-03 12:05:18
 * @LastEditors: Jake 
 * @LastEditTime: 2023-03-21 13:25:25
 * @FilePath: /bingxiang/my_app/lib/src/detailScreen.dart
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:my_app/components/animate_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_app/components/animate_app_bar.dart';
import 'package:my_app/components/gradient_button.dart';
import 'package:my_app/services/router_service.dart';
import 'package:my_app/storage/local_storage.dart';
import 'package:my_app/utils/global.dart';
import 'package:my_app/utils/app_style.dart';
import 'package:my_app/utils/constants.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:styled_text/styled_text.dart';
import 'package:go_router/go_router.dart';

class DetailScreen extends StatefulWidget {
  final List<String> step;
  final Map recipe;
  const DetailScreen({super.key, required this.step, required this.recipe});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return ScrollViewWithAnimateAppBar(
      appBarTitleWidget: Text('${widget.recipe['name']}'),
      lightModeColorTweenStart: Colors.white,
      hasBackBtn: true,
      isLightMode: true,
      actions: [
        GestureDetector(
          onTap: () {
            _addToPrepare(widget.recipe['id']);
          },
          child: Container(
              padding: EdgeInsets.only(right: 20.w, left: 15.w),
              child: Center(
                child: Text(
                  '备菜',
                  style: AppStyle.boldTextStyle(14.w),
                ),
              )),
        )
      ],
      bodyWidget: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 5.r),
          child: _scrollView()),
      onRefresh: () {},
    );
  }

  Widget _scrollView() {
    List<Widget> list = [];

    if (widget.recipe['time'] != null) {
      list = _addPrepareString(list, 'time');
    }
    if (widget.recipe['prepare'] != null && !widget.recipe['prepare'].isEmpty) {
      list = _addPrepareList(list, 'prepare');
    }
    if (widget.recipe['step'] != null && !widget.recipe['step'].isEmpty) {
      list = _addPrepareList(list, 'step');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list,
    );
  }

  _addEffectToString(String text, List<String> foodsList) {
    for (var i = 0; i < foodsList.length; i++) {
      text = text.replaceAll(foodsList[i], '<red>${foodsList[i]}</red>');
    }
    return text;
  }

  _addPrepareString(List list, String type) {
    list.add(Text(
      '${_getTitleNameByType(type)}: ${widget.recipe[type] ?? ''}',
      style: AppStyle.boldTextStyle(14.w),
    ));

    list.add(SizedBox(height: 20.r));
    return list;
  }

  _addPrepareList(List list, String type) {
    list.add(Text(
      _getTitleNameByType(type),
      style: AppStyle.boldTextStyle(14.w),
    ));
    for (var i = 0; i < widget.recipe[type].length; i++) {
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
                child:
                    // Text(steps[i]),
                    StyledText(
                  text: _addEffectToString(
                      widget.recipe[type][i], widget.recipe['mainFood']),
                  tags: {
                    'red': StyledTextTag(
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppStyle.systemRed)),
                  },
                ))
          ],
        ),
      ));
    }
    list.add(SizedBox(height: 20.r));
    return list;
  }

  _getTitleNameByType(type) {
    switch (type) {
      case 'step':
        return "主要步骤";
      case 'prepare':
        return "准备工作";
      case 'time':
        return "预计时间";
      default:
        return "";
    }
  }

  _addToPrepare(id) {
    var list = LocalStorage.prefs?.getStringList('prepareRecipeIds');
    list ??= [];
    if (list.contains(id.toString())) {
      EasyLoading.showToast('之前加过了，已在备菜中了');
    } else {
      list.add(id.toString());
      EasyLoading.showToast('已加入备菜');
    }
    print('list $list ');
    LocalStorage.prefs?.setStringList('prepareRecipeIds', list);
  }
}
