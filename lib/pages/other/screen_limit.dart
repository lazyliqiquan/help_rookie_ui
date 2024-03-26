import 'dart:math';

import 'package:flutter/material.dart';
import 'package:help_rookie_ui/config/screen.dart';
import 'package:help_rookie_ui/pages/other/icp_record.dart';
import 'package:help_rookie_ui/pages/other/top_navigation_bar.dart';

//显示页面之前，先判断一下当前屏幕是否达到最小显示尺寸要求
//fixme 有一个问题，就是如果屏幕大小，那么备案号就会显示不出来（不管了，显示不出来就显示不出来吧）
class ScreenLimit extends StatelessWidget {
  ScreenLimit(
      {Key? key,
      required this.child,
      this.widgetHeight = 1000,
      this.isCustom = true,
      this.floatWidgets = const [],
      this.showTopNavigationBar = true})
      : super(key: key);
  final Widget child;
  final List<Widget> floatWidgets; //侧边浮动按钮
  final double widgetHeight;

  //传递过来的child是否占据整个屏幕
  final bool isCustom;
  final bool showTopNavigationBar;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      final maxHeight = constraints.maxHeight;
      if (maxWidth < ScreenConfig.minWidth ||
          maxHeight < ScreenConfig.minHeight) {
        return const Center(child: Text(ScreenConfig.flunkShowText));
      }
      return Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.only(right: 22),
            child: Column(children: [
              if (showTopNavigationBar) const TopNavigationBar(),
              Container(
                height: max(widgetHeight,
                    maxHeight + ScreenConfig.verticalWidgetMargin),
                width: isCustom ? null : maxWidth,
                padding: const EdgeInsets.only(
                    left: ScreenConfig.horizontalWidgetMargin,
                    right: ScreenConfig.horizontalWidgetMargin,
                    top: ScreenConfig.verticalWidgetMargin,
                    bottom: ScreenConfig.verticalWidgetMargin),
                color: const Color(0xfff0f2f5),
                child: Center(
                  child: child,
                ),
              ),
              const ICPRecord()
            ]),
          ),
          ...floatWidgets //应该吧浮动组件放到后面，这样他的层级就会高一点
        ],
      );
    }));
  }
}
