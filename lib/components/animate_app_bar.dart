/*
 * @Author: Jake 
 * @Date: 2022-10-21 11:15:38
 * @LastEditors: Jake 
 * @LastEditTime: 2023-02-01 17:16:15
 * @FilePath: /bingxiang/my_app/lib/components/animate_app_bar.dart
 * @Description: 
 */

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_app/utils/app_style.dart';
import 'package:go_router/go_router.dart';

// ignore: library_private_types_in_public_api
GlobalKey<_ScrollViewWithAnimateAppBarState> scrollViewKey =
    GlobalKey<_ScrollViewWithAnimateAppBarState>();

class ScrollViewWithAnimateAppBar extends StatefulWidget {
  final Widget appBarTitleWidget;
  final Widget bodyWidget; //scrollview的body
  final bool isLightMode; //主题深浅模式
  final bool hasAvartar; //右侧是否有头像
  final bool hasBackBtn;

  final List<Widget> actions; //appbar右侧可点击的icon按钮组
  final double leadingWidthOfTitleInAppBar; //系统默认值是56.0
  final Widget appBarLeadingWidget; //一般放backIcon的地方
  final Color lightModeColorTweenStart; //只想shadow渐变就给个初始值，默认从透明开始渐变
  final Color lightModeColorTweenEnd;
  final Color darkModeColorTweenStart; //只想shadow渐变就给个初始值，默认从透明开始渐变
  final Color darkModeColorTweenEnd;
  final Color lightModeShadowColorTweenEnd; //不想要shadow渐变，给个白色透明值，默认渐变出白色阴影
  final Color darkModeShadowColorTweenEnd; //不想要shadow渐变，给个黑色透明值，默认渐变出黑色阴影
  final List bottomWidgetData; //目前用于主页tabbar上的按钮信息展示
  final bool
      hasBottomWidget; //需要放preferredsizewidget 与bottomWidget搭配使用 影响appbar高度
  final PreferredSizeWidget bottomWidget; //目前用于主页放tabbar的可水平滑动按钮
  final List<Widget> positionedWidgetList; //需要positioned的组件放在此list里
  final Function onRefresh;
  final Function? onClickBack;
  final bool extendBodyBehindAppBar;
  final Color scaffordBg;
  final bool hasFloatBtn; //只有首页会有的联系客服的悬浮按钮
  final double appbarHeight;

  const ScrollViewWithAnimateAppBar({
    Key? key,
    required this.appBarTitleWidget,
    required this.bodyWidget,
    required this.isLightMode,
    this.hasAvartar = false,
    this.actions = const [],
    this.bottomWidget = const TabBar(
      tabs: [],
    ),
    this.hasBottomWidget = false,
    this.bottomWidgetData = const [],
    this.leadingWidthOfTitleInAppBar = 56.0,
    this.appBarLeadingWidget = const SizedBox(),
    this.hasBackBtn = false,
    this.positionedWidgetList = const [],
    this.lightModeColorTweenStart = AppStyle.whiteTransparent,
    this.lightModeColorTweenEnd = Colors.white,
    this.darkModeColorTweenStart = AppStyle.backgroundBlackTransparent,
    this.darkModeColorTweenEnd = AppStyle.backgroundBlack,
    this.lightModeShadowColorTweenEnd = AppStyle.borderGrey,
    this.darkModeShadowColorTweenEnd = AppStyle.backgroundBlack,
    this.extendBodyBehindAppBar = false,
    this.scaffordBg = Colors.white,
    this.hasFloatBtn = false,
    required this.onRefresh,
    this.onClickBack,
    this.appbarHeight = 56.0,
  }) : super(key: key);

  @override
  State<ScrollViewWithAnimateAppBar> createState() =>
      _ScrollViewWithAnimateAppBarState();
}

class _ScrollViewWithAnimateAppBarState
    extends State<ScrollViewWithAnimateAppBar> with TickerProviderStateMixin {
  late AnimationController _colorAnimationController; //动态导航栏要用到
  late Animation _colorTween; //导航栏动态变化的背景色
  late Animation _shadowTween; //导航栏变化阴影颜色
  final ScrollController _primaryScrollController = ScrollController();

  @override
  void initState() {
    // NavigationBar动态背景颜色用到的
    _colorAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 0));
    // NavigationBa背景颜色
    _colorTween = ColorTween(
            begin: widget.isLightMode
                ? widget.lightModeColorTweenStart
                : widget.darkModeColorTweenStart,
            end: widget.isLightMode
                ? widget.lightModeColorTweenEnd
                : widget.darkModeColorTweenEnd)
        .animate(_colorAnimationController);
    _shadowTween = ColorTween(
            begin: widget.isLightMode
                ? widget.lightModeColorTweenStart
                : widget.darkModeColorTweenStart,
            end: widget.isLightMode
                ? widget.lightModeShadowColorTweenEnd
                : widget.darkModeShadowColorTweenEnd)
        .animate(_colorAnimationController);

    super.initState();
  }

  // NavigationBar渐变色要用到的 滑动监听
  bool _scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      _colorAnimationController.animateTo(scrollInfo.metrics.pixels / 100);
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    _primaryScrollController.removeListener(() {});
    _colorAnimationController.dispose();
    _primaryScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
        backgroundColor: widget.scaffordBg,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(
                widget.hasBottomWidget ? 115.0 : widget.appbarHeight),
            child: _positionedTopAppBar()),
        body: Container(
          constraints: const BoxConstraints(minHeight: double.infinity),
          child: Stack(children: _childrenList()),
        ));
  }

  List<Widget> _childrenList() {
    var list = [
      NotificationListener<ScrollNotification>(
          onNotification: _scrollListener,
          child: RefreshIndicator(
            edgeOffset: 0,
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 500));
              widget.onRefresh();
            },
            child: SingleChildScrollView(
                controller: _primaryScrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: widget.bodyWidget),
          )),

      const SizedBox()
      // _positionedTopAppBar(),
    ];

    for (var i = 0; i < widget.positionedWidgetList.length; i++) {
      list.add(widget.positionedWidgetList[i]);
    }
    return list;
  }

  Widget _positionedTopAppBar() {
    return (AnimatedBuilder(
        animation: _colorAnimationController,
        builder: (context, child) => Container(
              decoration: BoxDecoration(color: _colorTween.value, boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 0),
                    blurRadius: 5.w,
                    color: _shadowTween.value,
                    spreadRadius: 5.w),
              ]),
              // height: widget.hasBottomWidget ? 158.5.r : 88.r,
              // height: widget.hasBottomWidget ? 140.5.r : 80.r,
              child: AppBar(
                shape: widget.hasBottomWidget
                    ? Border(
                        bottom:
                            BorderSide(color: AppStyle.cardBgGrey, width: 5.r))
                    : null,
                leadingWidth: widget.leadingWidthOfTitleInAppBar,
                backgroundColor: _colorTween.value,
                // backgroundColor: Colors.amber,
                actions: widget.actions,
                elevation:
                    0, //如果设置这个模糊当bar背景透明时会有bug，不流畅,因此在外层包裹container来实现shadow
                titleSpacing: 0.0,
                leading: widget.hasBackBtn
                    ? _appBarLeadingWidget()
                    : widget.appBarLeadingWidget,
                title: widget.appBarTitleWidget,
                bottom: widget.hasBottomWidget ? widget.bottomWidget : null,
              ),
            )));
  }

  Widget _appBarLeadingWidget() {
    return (IconButton(
      onPressed: () {
        if (widget.onClickBack != null) {
          widget.onClickBack!();
        } else {
          context.pop();
        }
      },
      icon: Icon(
        Icons.arrow_back,
        color: widget.isLightMode ? AppStyle.textColorBlack : Colors.white,
        size: 25.w,
      ),
    ));
  }

  void scrollToTop() {
    _primaryScrollController.animateTo(0.0,
        duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
  }
}
