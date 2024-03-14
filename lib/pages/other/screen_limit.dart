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
      this.sideFloatWidget,
      this.topFloatWidget,
      this.widgetHeight = 1000,
      this.isCustom = true,
      this.showTopNavigationBar = true})
      : super(key: key);
  final Widget child;
  final Widget? sideFloatWidget; //侧边浮动按钮
  final Widget? topFloatWidget; //顶部浮动按钮
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
              if (!isCustom)
                SizedBox(
                  width: maxWidth,
                  height: maxHeight,
                  child: child,
                )
              else
                Container(
                  height: widgetHeight,
                  color: const Color(0xfff0f2f5),
                  child: Center(
                    child: child,
                  ),
                ),
              const ICPRecord()
            ]),
          ),
          if (sideFloatWidget != null) sideFloatWidget!,
          if (topFloatWidget != null) topFloatWidget!,
        ],
      );
    }));
  }
}
