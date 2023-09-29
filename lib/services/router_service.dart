/*
 * @Author: Jake 
 * @Date: 2022-10-05 16:15:07
 * @LastEditors: Jake 
 * @LastEditTime: 2023-09-25 20:51:29
 * @FilePath: /bingxiang/my_app/lib/services/router_service.dart
 * @Description: 
 */
import 'dart:core';
import 'package:go_router/go_router.dart';
import 'package:my_app/src/can_cook_screen.dart';
import 'package:my_app/src/detail_screen.dart';
import 'package:my_app/src/tabs.dart';

enum ScreenPath {
  tabs('/'),
  home('/home'),
  canCook('/can_cook'),
  detail('/detail');

  final String value;
  const ScreenPath(this.value);
}

class RouterService {
  static final GoRouter router =
      GoRouter(initialLocation: ScreenPath.tabs.value, routes: <GoRoute>[
    GoRoute(
        path: ScreenPath.tabs.value,
        builder: (context, state) {
          int initIndex = int.parse(state.params['initIndex'] ?? "0");
          return Tabs(
            initIndex: initIndex,
          );
        }),
    GoRoute(
        path: ScreenPath.canCook.value,
        builder: (context, state) {
          return const CanCookScreen();
        }),
    GoRoute(
        path: ScreenPath.detail.value,
        builder: (context, state) {
          return DetailScreen(
            step: (state.extra as Map)['step'],
            recipe: (state.extra as Map)['recipe'],
          );
        })
  ]);
}
