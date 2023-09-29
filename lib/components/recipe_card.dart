/*
 * @Author: Jake 
 * @Date: 2023-03-20 17:10:59
 * @LastEditors: Jake 
 * @LastEditTime: 2023-09-25 21:14:21
 * @FilePath: /bingxiang/my_app/lib/components/recipe_card.dart
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:my_app/storage/local_storage.dart';
import 'package:my_app/utils/app_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

// title: resultArr[i]['name'],
//           img: resultArr[i]['img'] ?? '',
//           hasStep: resultArr[i]['step'] != null &&
//               resultArr[i]['step'].length != 0,
//           containNameArr: resultArr[i]['mainFood'],
class RecipeCard extends StatefulWidget {
  final String img;
  final String title;
  // final List<Widget> contain;
  // final List<Widget> unContain;
  final Map data;
  final List<String> containNameArr;
  final List<String> unContainNameArr;
  final bool canAddToCart;
  final bool hasStep;
  final Function? onTap;
  final Function onClickCard;
  const RecipeCard(
      {super.key,
      this.img = '',
      this.containNameArr = const [],
      required this.title,
      required this.data,
      // this.contain = const [],
      // this.unContain = const [],
      this.unContainNameArr = const [],
      this.canAddToCart = false,
      this.onTap,
      required this.onClickCard,
      this.hasStep = false});

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  List<String> shoppingCartIds = [];
  bool inshoppingCart = false;

  @override
  void initState() {
    super.initState();
    shoppingCartIds =
        LocalStorage.prefs?.getStringList('shoppingCartIds') ?? [];
    inshoppingCart = shoppingCartIds.contains(widget.data['id'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => widget.onClickCard(),
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                style: BorderStyle.solid,
                color: const Color(0xFFDDDDDD).withOpacity(0.1),
                width: 1,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFFDDDDDD),
                  blurRadius: 8,
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(10.w, 8.r, 10.w, 8.r),
            margin: EdgeInsets.only(bottom: 8.r),
            child: Row(
              children: [
                // 图片
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(18.r)),
                  child: Image.network(widget.img,
                      height: 80.w, width: 80.w, fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80.w,
                      height: 80.w,
                      color: AppStyle.textColorGrey,
                    );
                  }),
                ),
                SizedBox(width: 10.w),
                // 正文
                SizedBox(
                    width: 220.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: 220.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // 包含步骤
                                widget.hasStep
                                    ? Padding(
                                        padding: EdgeInsets.only(right: 3.w),
                                        child: Container(
                                          height: 15,
                                          padding: EdgeInsets.only(
                                              left: 3.r, right: 3.r),
                                          decoration: BoxDecoration(
                                            color: AppStyle.primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(5.r),
                                          ),
                                          child: Center(
                                              child: Text(
                                            '含步骤',
                                            style: AppStyle.regularTextStyle(
                                                10.w,
                                                color: Colors.white),
                                          )),
                                        ))
                                    : const SizedBox(),
                                widget.data['needFried'] != null &&
                                        widget.data['needFried']
                                    ? Padding(
                                        padding: EdgeInsets.only(right: 3.w),
                                        child: Container(
                                          height: 15,
                                          padding: EdgeInsets.only(
                                              left: 3.r, right: 3.r),
                                          decoration: BoxDecoration(
                                            color: AppStyle.systemOriange,
                                            borderRadius:
                                                BorderRadius.circular(5.r),
                                          ),
                                          child: Center(
                                              child: Text(
                                            '需油炸',
                                            style: AppStyle.regularTextStyle(
                                                10.w,
                                                color: Colors.white),
                                          )),
                                        ))
                                    : const SizedBox(),
                                Text(
                                  widget.title,
                                  style: AppStyle.boldTextStyle(14.w,
                                      color: AppStyle.textColorBlack),
                                ),
                                const Expanded(flex: 1, child: SizedBox()),
                                widget.canAddToCart
                                    ? GestureDetector(
                                        onTap: () {
                                          if (!inshoppingCart) {
                                            _addItemToShoppingCart(
                                                widget.unContainNameArr);
                                          } else {
                                            EasyLoading.showToast('已在购物车内');
                                          }
                                        },
                                        child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                4.r, 2.r, 3.r, 3.r),
                                            decoration: BoxDecoration(
                                              color: inshoppingCart
                                                  ? AppStyle.textColorGrey
                                                  : AppStyle.primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(5.r),
                                            ),
                                            child: Center(
                                              child: Text(
                                                inshoppingCart ? '已加入' : '加购物车',
                                                style:
                                                    AppStyle.regularTextStyle(
                                                        12.sp,
                                                        color: Colors.white),
                                              ),
                                            )),
                                      )
                                    : const SizedBox()
                              ],
                            )),
                        SizedBox(height: 10.r),
                        if (widget.containNameArr.isNotEmpty)
                          Wrap(
                              spacing: 2,
                              runSpacing: 5,
                              direction: Axis.horizontal,
                              children: _containWrapChild()),
                        SizedBox(height: 5.r),
                        widget.unContainNameArr.isEmpty
                            ? const SizedBox()
                            : Wrap(
                                spacing: 2,
                                runSpacing: 5,
                                direction: Axis.horizontal,
                                children: _unContainWrapChild()),
                      ],
                    )),
              ],
            )));
  }

  _containWrapChild() {
    List<Widget> containList = [
      Text(
        '包含: ',
        style: AppStyle.boldTextStyle(12.w),
      )
    ];
    for (var i = 0; i < widget.containNameArr.length; i++) {
      containList.add(
        Text(widget.containNameArr[i],
            style:
                AppStyle.regularTextStyle(12.w, color: AppStyle.systemGreen)),
      );
    }
    return containList;
  }

  _unContainWrapChild() {
    List<Widget> unContainList = [
      Text(
        '缺少: ',
        style: AppStyle.boldTextStyle(12.w, color: AppStyle.systemRed),
      )
    ];
    for (var i = 0; i < widget.unContainNameArr.length; i++) {
      unContainList.add(
        Text(widget.unContainNameArr[i],
            style: AppStyle.mediumTextStyle(12.w, color: AppStyle.systemRed)),
      );
    }
    return unContainList;
  }

  _addItemToShoppingCart(unContainNameArr) {
    List<String> list = LocalStorage.prefs?.getStringList('shoppingCart') ?? [];
    list.addAll(unContainNameArr);
    list.toSet().toList();
    LocalStorage.prefs?.setStringList('shoppingCart', list);
    EasyLoading.showToast('已添加至购物车');
    // shoppingCartIds
    List<String> shoppingCartIds =
        LocalStorage.prefs?.getStringList('shoppingCartIds') ?? [];
    shoppingCartIds.add(widget.data['id'].toString());
    LocalStorage.prefs?.setStringList('shoppingCartIds', shoppingCartIds);
    setState(() {
      inshoppingCart = true;
    });
  }
}
