import 'package:flutter/material.dart';
import 'package:my_app/components/animate_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_app/components/pop_up_view.dart';
import 'package:my_app/components/shopping_cart_card.dart';
import 'package:my_app/storage/local_storage.dart';
import 'package:my_app/utils/global.dart';
import 'package:my_app/utils/app_style.dart';
import 'package:collection/collection.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen>
    with _ShoppingCartScreenStateMixin {
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollViewWithAnimateAppBar(
      appBarTitleWidget: const Text('购物车'),
      lightModeColorTweenStart: Colors.white,
      actions: [
        GestureDetector(
          onTap: () => _onClickClearAll(),
          child: Container(
              padding: EdgeInsets.only(right: 20.w, left: 15.w),
              child: Center(
                child: Text(
                  '清空',
                  style: AppStyle.boldTextStyle(14.w),
                ),
              )),
        ),
        GestureDetector(
          onTap: () => _showAllFoods(),
          child: Container(
              padding: EdgeInsets.only(right: 20.w, left: 15.w),
              child: Center(
                child: Text(
                  '添加',
                  style: AppStyle.boldTextStyle(14.w),
                ),
              )),
        )
      ],
      hasBackBtn: false,
      leadingWidthOfTitleInAppBar: 20.w,
      isLightMode: true,
      bodyWidget: Padding(
          padding: EdgeInsets.only(
              left: 20.w, right: 20.w, top: 25.r, bottom: 100.r),
          child: Column(children: _bodyList())),
      onRefresh: () {},
    );
  }

  List<Widget> _bodyList() {
    return datalist
        .mapIndexed((index, item) => ShoppingCartCard(
            name: item,
            onClickDelete: () => _deleteItem(index),
            onClickBought: () => _haveBoughtItem(index)))
        .toList();
  }

  Widget _addItemsContainer(String type) {
    List<Widget> list = [];
    for (var i = 0; i < wannaBuyList.length; i++) {
      if (wannaBuyList[i]['type'] == type) {
        list.add(GestureDetector(
          onTap: () async {
            setState(() {
              datalist.add(wannaBuyList[i]['name']);
              datalist = datalist.toSet().toList();
              LocalStorage.prefs?.setStringList('shoppingCart', datalist);
              EasyLoading.showToast('已添加 ${wannaBuyList[i]['name']}');
            });
          },
          child: Container(
              padding: EdgeInsets.fromLTRB(5.w, 3.r, 5.w, 3.r),
              decoration: BoxDecoration(
                color: wannaBuyList[i]['isSelected'] as bool
                    ? AppStyle.primaryColor
                    : AppStyle.cardBgGrey,
                borderRadius: BorderRadius.circular(3.r),
              ),
              child: Text(wannaBuyList[i]['name'] as String)),
        ));
      }
    }
    return Wrap(
      spacing: 2,
      runSpacing: 5,
      children: list,
    );
  }

  _showAllFoods() async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.w),
            topRight: Radius.circular(20.w),
          ),
        ),
        builder: (BuildContext context) {
          return PopUpView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  '选择要添加到购物车的食材',
                  style: AppStyle.boldTextStyle(16.w),
                ),
              ),
              SizedBox(height: 18.r),
              Text('蔬菜', style: AppStyle.boldTextStyle(14.w)),
              _addItemsContainer('蔬菜'),
              SizedBox(height: 18.r),
              Text('肉类', style: AppStyle.boldTextStyle(14.w)),
              _addItemsContainer('肉类'),
              SizedBox(height: 18.r),
              Text('中性', style: AppStyle.boldTextStyle(14.w)),
              _addItemsContainer('中性'),
              SizedBox(height: 18.r),
              Text('配料', style: AppStyle.boldTextStyle(14.w)),
              _addItemsContainer('配料'),
              SizedBox(height: 18.r),
            ]),
          );
        });
  }
}

mixin _ShoppingCartScreenStateMixin<T extends StatefulWidget> on State<T> {
  List<String> datalist = [];
  List wannaBuyList = [];
  // 获取之前保存的想要购买的食材列表
  getData() async {
    await LocalStorage.init();
    datalist =
        LocalStorage.prefs?.getStringList('shoppingCart')?.toSet().toList() ??
            [];
    List<Map> allRefrigeStorage = Global.refrigeStorage;
    for (var i = 0; i < allRefrigeStorage.length; i++) {
      if (allRefrigeStorage[i]['isSelected'] == false) {
        wannaBuyList.add(allRefrigeStorage[i]);
      }
    }
    setState(() {
      wannaBuyList = wannaBuyList;
    });
  }

  // 删除食材
  _deleteItem(index) {
    datalist.removeAt(index);
    setState(() {
      datalist = datalist;
    });
    LocalStorage.prefs?.setStringList('shoppingCart', datalist);
    EasyLoading.showToast('已删除');
  }

  // 点击食材购买
  _haveBoughtItem(index) {
    var list = LocalStorage.prefs?.getStringList('refrigeStorage');
    if (list != null) {
      list.add(datalist[index]);
    } else {
      list = [datalist[index]];
    }
    LocalStorage.prefs?.setStringList('refrigeStorage', list);
    datalist.removeAt(index);
    setState(() {
      datalist = datalist;
    });
    // 把已买的食材保存到本地
    LocalStorage.prefs?.setStringList('shoppingCart', datalist);
    EasyLoading.showToast('已购买');
  }

// 清空购物车
  _onClickClearAll() {
    setState(() {
      datalist = [];
    });
    LocalStorage.prefs?.setStringList('shoppingCart', []);
    LocalStorage.prefs?.setStringList('shoppingCartIds', []);
    EasyLoading.showToast('已清空');
  }
}
